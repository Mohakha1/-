#!/usr/bin/env python3
"""Inject slide transitions + sequential fade entrance animations into a .pptx."""
import sys, re, zipfile, shutil, os

SRC = os.path.abspath(sys.argv[1])
DST = os.path.abspath(sys.argv[2])
WORK = "/tmp/pptx_anim"

if os.path.exists(WORK):
    shutil.rmtree(WORK)
os.makedirs(WORK)
with zipfile.ZipFile(SRC) as z:
    z.extractall(WORK)

TRANSITION = (
    '<mc:AlternateContent xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006">'
    '<mc:Choice xmlns:p14="http://schemas.microsoft.com/office/powerpoint/2010/main" Requires="p14">'
    '<p:transition spd="slow" p14:dur="700"><p:fade/></p:transition>'
    '</mc:Choice>'
    '<mc:Fallback>'
    '<p:transition spd="slow"><p:fade/></p:transition>'
    '</mc:Fallback>'
    '</mc:AlternateContent>'
)

def build_timing(spids):
    counter = [10]
    def nid():
        counter[0] += 1
        return counter[0]
    pars = []
    for i, sp in enumerate(spids):
        delay = "0" if i == 0 else "250"   # first on load, rest stagger 250ms after previous
        a, b, c, cs, ce = nid(), nid(), nid(), nid(), nid()
        pars.append(
            f'<p:par><p:cTn id="{a}" fill="hold">'
            f'<p:stCondLst><p:cond delay="{delay}"/></p:stCondLst><p:childTnLst>'
            f'<p:par><p:cTn id="{b}" fill="hold">'
            f'<p:stCondLst><p:cond delay="0"/></p:stCondLst><p:childTnLst>'
            f'<p:par><p:cTn id="{c}" presetID="10" presetClass="entr" presetSubtype="0" '
            f'fill="hold" grpId="0" nodeType="afterEffect">'
            f'<p:stCondLst><p:cond delay="0"/></p:stCondLst><p:childTnLst>'
            f'<p:set><p:cBhvr><p:cTn id="{cs}" dur="1" fill="hold">'
            f'<p:stCondLst><p:cond delay="0"/></p:stCondLst></p:cTn>'
            f'<p:tgtEl><p:spTgt spid="{sp}"/></p:tgtEl>'
            f'<p:attrNameLst><p:attrName>style.visibility</p:attrName></p:attrNameLst></p:cBhvr>'
            f'<p:to><p:strVal val="visible"/></p:to></p:set>'
            f'<p:animEffect transition="in" filter="fade"><p:cBhvr>'
            f'<p:cTn id="{ce}" dur="500"/><p:tgtEl><p:spTgt spid="{sp}"/></p:tgtEl>'
            f'</p:cBhvr></p:animEffect>'
            f'</p:childTnLst></p:cTn></p:par>'
            f'</p:childTnLst></p:cTn></p:par>'
            f'</p:childTnLst></p:cTn></p:par>'
        )
    inner = "".join(pars)
    return (
        '<p:timing><p:tnLst><p:par>'
        '<p:cTn id="1" dur="indefinite" restart="never" nodeType="tmRoot"><p:childTnLst>'
        '<p:seq concurrent="1" nextAc="seek">'
        '<p:cTn id="2" dur="indefinite" nodeType="mainSeq"><p:childTnLst>'
        f'{inner}'
        '</p:childTnLst></p:cTn>'
        '<p:prevCondLst><p:cond evt="onPrev" delay="0"><p:tgtEl><p:sldTgt/></p:tgtEl></p:cond></p:prevCondLst>'
        '<p:nextCondLst><p:cond evt="onNext" delay="0"><p:tgtEl><p:sldTgt/></p:tgtEl></p:cond></p:nextCondLst>'
        '</p:seq></p:childTnLst></p:cTn></p:par></p:tnLst></p:timing>'
    )

slides_dir = os.path.join(WORK, "ppt", "slides")
for fn in sorted(os.listdir(slides_dir)):
    if not re.match(r"slide\d+\.xml$", fn):
        continue
    path = os.path.join(slides_dir, fn)
    with open(path, encoding="utf-8") as f:
        xml = f.read()

    # collect top-level shape ids (skip the first cNvPr = spTree group)
    ids = re.findall(r'<p:cNvPr id="(\d+)"', xml)
    spids = ids[1:] if len(ids) > 1 else ids

    block = TRANSITION + build_timing(spids)
    xml = xml.replace("</p:sld>", block + "</p:sld>")

    with open(path, "w", encoding="utf-8") as f:
        f.write(xml)
    print(f"{fn}: {len(spids)} shapes animated")

if os.path.exists(DST):
    os.remove(DST)
base = os.getcwd()
os.chdir(WORK)
with zipfile.ZipFile(DST, "w", zipfile.ZIP_DEFLATED) as z:
    for root, _, files in os.walk("."):
        for file in files:
            fp = os.path.join(root, file)
            z.write(fp, os.path.relpath(fp, "."))
os.chdir(base)
print("WROTE", DST)
