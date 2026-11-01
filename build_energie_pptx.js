const pptxgen = require("pptxgenjs");
const p = new pptxgen();
p.layout = "LAYOUT_WIDE"; // 13.33 x 7.5
p.author = "Energiewende";
p.title = "Erneuerbare Energien";

// palette
const NIGHT = "081318", DEEP = "0E2430", TEAL = "10343C", PANEL = "123038";
const ICE = "E9F4F1", ICEDIM = "ACC6C3", LTBG = "E9F4F1", LTDIM = "4A6560";
const SOLAR = "F3B53F", SOLARBR = "FFCF61", GREEN = "3FB584", GREENBR = "5FD6A0";
const LINE = "1C3A42";

const HEAD = "Arial";          // bold = condensed-impact stand-in, safe font
const BODY = "Arial";
const SERIF = "Bookman Old Style"; // italic accent words

const W = 13.33, H = 7.5, MX = 0.9;

function kicker(s, text, color, y) {
  s.addShape(p.ShapeType.line, { x: MX, y: y + 0.09, w: 0.34, h: 0, line: { color, width: 1.5 } });
  s.addText(text.toUpperCase(), {
    x: MX + 0.45, y: y - 0.1, w: 9, h: 0.4, isTextBox: true, margin: 0,
    fontFace: BODY, fontSize: 12, bold: true, color, charSpacing: 4,
  });
}
function pageno(s, n) {
  s.addText([{ text: String(n).padStart(2,"0"), options:{color:SOLARBR} },
             { text: " / 08", options:{color:ICEDIM} }], {
    x: W - 2.2, y: 0.32, w: 1.6, h: 0.4, isTextBox: true, align: "right",
    fontFace: BODY, fontSize: 11, bold: true, charSpacing: 3,
  });
}
function brand(s, dark) {
  s.addShape(p.ShapeType.ellipse, { x: MX, y: 0.4, w: 0.12, h: 0.12, fill:{color:SOLAR} });
  s.addText("ENERGIEWENDE", { x: MX+0.25, y: 0.3, w: 4, h: 0.35, isTextBox:true, margin:0,
    fontFace: BODY, fontSize: 11, bold: true, color: dark?ICEDIM:LTDIM, charSpacing: 4 });
}
function bar(s, dark) {
  s.addShape(p.ShapeType.rect, { x: 0, y: H-0.07, w: W*0.5, h: 0.07,
    fill: { color: SOLAR }, line:{type:"none"} });
}

// ---------- 1 COVER ----------
let s = p.addSlide();
s.background = { color: NIGHT };
// sun glow motif (layered translucent circles)
s.addShape(p.ShapeType.ellipse, { x: 8.6, y: -2.6, w: 7.5, h: 7.5, fill:{color:SOLAR, transparency:82}, line:{type:"none"} });
s.addShape(p.ShapeType.ellipse, { x: 9.6, y: -1.6, w: 5.5, h: 5.5, fill:{color:SOLARBR, transparency:72}, line:{type:"none"} });
s.addShape(p.ShapeType.ellipse, { x: 10.4, y: -0.8, w: 3.9, h: 3.9, fill:{color:SOLARBR, transparency:55}, line:{type:"none"} });
brand(s, true); pageno(s, 1);
kicker(s, "Die Energiewende · 2026", SOLARBR, 2.35);
s.addText([
  { text:"DIE ZUKUNFT\n", options:{} },
  { text:"IST ", options:{color:ICE} },
  { text:"ERNEUERBAR", options:{} },
], { x: MX, y: 2.7, w: 10.5, h: 2.4, isTextBox:true, margin:0,
     fontFace: HEAD, fontSize: 66, bold: true, color: ICE, lineSpacingMultiple: 0.95, charSpacing: 1 });
s.addText("Sonne, Wind und Wasser liefern heute mehr Strom als je zuvor — sauber, sicher und unerschöpflich. Zeit, den Wandel zu gestalten.",
  { x: MX, y: 5.25, w: 7.2, h: 1, isTextBox:true, margin:0, fontFace: BODY, fontSize: 16, color: ICEDIM, lineSpacingMultiple: 1.3 });
s.addShape(p.ShapeType.roundRect, { x: MX, y: 6.35, w: 2.7, h: 0.6, rectRadius: 0.3, fill:{color:SOLAR}, line:{type:"none"} });
s.addText("JETZT UMSTEIGEN  →", { x: MX, y: 6.35, w: 2.7, h: 0.6, isTextBox:true, align:"center", fontFace:BODY, fontSize:12, bold:true, color:NIGHT, charSpacing:2 });
bar(s, true);

// ---------- 2 WARUM (light) ----------
s = p.addSlide();
s.background = { color: LTBG };
brand(s, false); pageno(s, 2);
kicker(s, "Warum jetzt", "1F7D58", 1.5);
s.addText([
  { text:"JEDE KWH\n", options:{color:NIGHT} },
  { text:"zählt.", options:{fontFace:SERIF, italic:true, color:"1F7D58"} },
], { x: MX, y: 1.9, w: 7, h: 2.2, isTextBox:true, margin:0, fontFace:HEAD, fontSize:60, bold:true, lineSpacingMultiple:0.98 });
s.addText("Fossile Energie ist endlich, teuer und heizt das Klima auf. Erneuerbare sind längst die günstigste Stromquelle der Geschichte — die Frage ist nicht ob, sondern wie schnell.",
  { x: MX, y: 4.7, w: 6.3, h: 1.6, isTextBox:true, margin:0, fontFace:BODY, fontSize:16, color:LTDIM, lineSpacingMultiple:1.35 });
// stat tiles right
const tiles = [
  { b:"1,5°C", t:"das Ziel von Paris", bg:DEEP },
  { b:"−90%", t:"Solarkosten seit 2010", bg:TEAL },
  { b:"∞", t:"Brennstoff: kostenlos", bg:DEEP },
];
let ty = 1.6;
tiles.forEach((it,i) => {
  const th = i===0 ? 1.55 : 1.55;
  s.addShape(p.ShapeType.roundRect, { x: 8.3, y: ty, w: 4.1, h: th, rectRadius:0.08, fill:{color:it.bg}, line:{type:"none"} });
  s.addText(it.b, { x: 8.6, y: ty+0.2, w: 3.6, h: 0.9, isTextBox:true, margin:0, fontFace:HEAD, fontSize:46, bold:true, color:SOLARBR });
  s.addText(it.t.toUpperCase(), { x: 8.6, y: ty+1.05, w: 3.6, h: 0.4, isTextBox:true, margin:0, fontFace:BODY, fontSize:11, color:ICEDIM, charSpacing:2 });
  ty += th + 0.18;
});

// ---------- 3 ZAHLEN (dark) ----------
s = p.addSlide();
s.background = { color: DEEP };
brand(s, true); pageno(s, 3);
kicker(s, "Die Zahlen", SOLARBR, 1.6);
s.addText([{text:"DER WANDEL ", options:{color:ICE}}, {text:"läuft", options:{fontFace:SERIF, italic:true, color:GREENBR}}],
  { x: MX, y: 2.0, w: 11, h: 1.3, isTextBox:true, margin:0, fontFace:HEAD, fontSize:58, bold:true });
const stats = [
  { b:"30%", t:"des Weltstroms aus Erneuerbaren" },
  { b:"50%", t:"Anteil in Deutschland 2025" },
  { b:"+13%", t:"Ausbau pro Jahr, weltweit" },
];
let sx = MX;
const sw = (W - 2*MX - 0.6)/3;
stats.forEach(it => {
  s.addShape(p.ShapeType.roundRect, { x: sx, y: 3.5, w: sw, h: 2.0, rectRadius:0.08, fill:{color:TEAL}, line:{color:LINE, width:1} });
  s.addText(it.b, { x: sx+0.3, y: 3.7, w: sw-0.6, h: 1.0, isTextBox:true, margin:0, fontFace:HEAD, fontSize:62, bold:true, color:SOLARBR });
  s.addText(it.t.toUpperCase(), { x: sx+0.3, y: 4.8, w: sw-0.6, h: 0.6, isTextBox:true, margin:0, fontFace:BODY, fontSize:11.5, color:ICEDIM, charSpacing:1.5, lineSpacingMultiple:1.2 });
  sx += sw + 0.3;
});
s.addText("Solar und Wind wachsen schneller als jede Energieform zuvor. Die Technik ist reif, die Kosten fallen weiter.",
  { x: MX, y: 5.9, w: 10, h: 0.8, isTextBox:true, margin:0, fontFace:BODY, fontSize:15, color:ICEDIM, lineSpacingMultiple:1.3 });

// ---------- 4 QUELLEN (dark) ----------
s = p.addSlide();
s.background = { color: DEEP };
brand(s, true); pageno(s, 4);
kicker(s, "Die Quellen", SOLARBR, 1.3);
s.addText([{text:"VIER KRÄFTE ", options:{color:ICE}}, {text:"der Natur", options:{fontFace:SERIF, italic:true, color:GREENBR}}],
  { x: MX, y: 1.7, w: 11, h: 1.2, isTextBox:true, margin:0, fontFace:HEAD, fontSize:52, bold:true });
const sources = [
  { ic:"☀", h:"Solar", t:"Photovoltaik wandelt Sonnenlicht direkt in Strom — auf jedem Dach.", c:SOLAR },
  { ic:"≈", h:"Wind", t:"Turbinen an Land und auf See liefern Strom, wenn die Sonne schläft.", c:GREENBR },
  { ic:"≋", h:"Wasser", t:"Wasserkraft speichert und erzeugt — der verlässlichste Taktgeber.", c:"4FB0C8" },
  { ic:"✿", h:"Bio & Geo", t:"Biomasse und Erdwärme füllen Lücken und heizen ganze Städte.", c:GREEN },
];
let cx = MX;
const cw = (W - 2*MX - 3*0.3)/4;
sources.forEach(it => {
  s.addShape(p.ShapeType.roundRect, { x: cx, y: 3.3, w: cw, h: 3.1, rectRadius:0.1, fill:{color:TEAL}, line:{color:LINE, width:1} });
  s.addShape(p.ShapeType.ellipse, { x: cx+0.3, y: 3.6, w: 0.7, h: 0.7, fill:{color:NIGHT}, line:{color:it.c, width:1.5} });
  s.addText(it.ic, { x: cx+0.3, y: 3.6, w: 0.7, h: 0.7, isTextBox:true, align:"center", valign:"middle", margin:0, fontFace:BODY, fontSize:20, color:it.c });
  s.addText(it.h, { x: cx+0.3, y: 4.5, w: cw-0.6, h: 0.45, isTextBox:true, margin:0, fontFace:HEAD, fontSize:19, bold:true, color:ICE });
  s.addText(it.t, { x: cx+0.3, y: 5.0, w: cw-0.55, h: 1.3, isTextBox:true, margin:0, fontFace:BODY, fontSize:12.5, color:ICEDIM, lineSpacingMultiple:1.25 });
  cx += cw + 0.3;
});

// ---------- 5 STROMMIX (light, native chart) ----------
s = p.addSlide();
s.background = { color: LTBG };
brand(s, false); pageno(s, 5);
kicker(s, "Der Strommix", "1F7D58", 1.4);
s.addText([{text:"WOHER DER\n", options:{color:NIGHT}}, {text:"Strom kommt", options:{fontFace:SERIF, italic:true, color:"1F7D58"}}],
  { x: MX, y: 1.8, w: 5.5, h: 2.2, isTextBox:true, margin:0, fontFace:HEAD, fontSize:48, bold:true, lineSpacingMultiple:0.98 });
s.addText("Anteil der Quellen am Stromverbrauch — der Weg zur Klimaneutralität in Prozent.",
  { x: MX, y: 4.5, w: 4.8, h: 1.2, isTextBox:true, margin:0, fontFace:BODY, fontSize:15, color:LTDIM, lineSpacingMultiple:1.35 });
s.addChart(p.ChartType.bar, [{
  name: "Anteil",
  labels: ["Wind","Solar","Biomasse","Wasser","Fossil / Rest"],
  values: [31, 24, 14, 9, 22],
}], {
  x: 6.7, y: 1.5, w: 5.9, h: 5.0,
  barDir: "bar",
  chartColors: [GREEN, SOLAR, GREENBR, "4FB0C8", "9AAFB0"],
  showTitle: false, showLegend: false,
  showValue: true, dataLabelPosition: "outEnd", dataLabelColor: NIGHT, dataLabelFontFace: BODY, dataLabelFontSize: 13, dataLabelFontBold: true,
  valAxisHidden: true, valGridLine: { style: "none" },
  catAxisLabelColor: NIGHT, catAxisLabelFontFace: BODY, catAxisLabelFontSize: 13, catAxisLabelFontBold: true,
  catGridLine: { style: "none" },
  barGapWidthPct: 55,
  valAxisMaxVal: 40, valAxisMinVal: 0,
});

// ---------- 6 QUOTE (solar bg) ----------
s = p.addSlide();
s.background = { color: SOLAR };
s.addShape(p.ShapeType.ellipse, { x: -2, y: 4.5, w: 6, h: 6, fill:{color:"D8902A", transparency:60}, line:{type:"none"} });
kicker(s, "Der Kern", "3A2607", 1.9);
s.addText("„Die Sonne schickt keine Rechnung. Wir müssen sie nur ernten.“",
  { x: MX, y: 2.4, w: 10.5, h: 2.8, isTextBox:true, margin:0, fontFace:SERIF, italic:true, fontSize:44, color:"2A1C04", lineSpacingMultiple:1.1 });
s.addText("— LEITSATZ DER ENERGIEWENDE", { x: MX, y: 5.4, w: 8, h: 0.4, isTextBox:true, margin:0, fontFace:BODY, fontSize:12, bold:true, color:"5A3E0E", charSpacing:3 });
pageno(s, 6);

// ---------- 7 WEG (dark, steps) ----------
s = p.addSlide();
s.background = { color: DEEP };
brand(s, true); pageno(s, 7);
kicker(s, "Der Weg", SOLARBR, 1.3);
s.addText([{text:"IN VIER ", options:{color:ICE}}, {text:"Schritten", options:{fontFace:SERIF, italic:true, color:GREENBR}}],
  { x: MX, y: 1.7, w: 11, h: 1.1, isTextBox:true, margin:0, fontFace:HEAD, fontSize:50, bold:true });
const steps = [
  { n:"01", h:"Erzeugen", t:"Dächer, Felder und Meere in Kraftwerke verwandeln.", tag:"heute" },
  { n:"02", h:"Speichern", t:"Batterien und Wasserstoff puffern Sonne für die Nacht.", tag:"+2 Jahre" },
  { n:"03", h:"Vernetzen", t:"Smarte Netze verteilen Strom über Grenzen hinweg.", tag:"+5 Jahre" },
  { n:"04", h:"Elektrifizieren", t:"Wärme, Verkehr und Industrie laufen sauber mit Strom.", tag:"2040" },
];
let sy = 3.0;
steps.forEach(it => {
  s.addText(it.n, { x: MX, y: sy, w: 1.0, h: 0.7, isTextBox:true, margin:0, fontFace:HEAD, fontSize:30, bold:true, color:SOLAR });
  s.addText(it.h, { x: MX+1.2, y: sy-0.05, w: 4, h: 0.5, isTextBox:true, margin:0, fontFace:HEAD, fontSize:22, bold:true, color:ICE });
  s.addText(it.t, { x: MX+1.2, y: sy+0.42, w: 7.5, h: 0.4, isTextBox:true, margin:0, fontFace:BODY, fontSize:13.5, color:ICEDIM });
  s.addText(it.tag.toUpperCase(), { x: W-3.0, y: sy+0.05, w: 2.1, h: 0.4, isTextBox:true, align:"right", margin:0, fontFace:BODY, fontSize:12, bold:true, color:GREENBR, charSpacing:2 });
  sy += 0.95;
  s.addShape(p.ShapeType.line, { x: MX, y: sy-0.12, w: W-2*MX, h: 0, line:{color:LINE, width:1} });
});

// ---------- 8 CLOSE (dark) ----------
s = p.addSlide();
s.background = { color: NIGHT };
s.addShape(p.ShapeType.ellipse, { x: -2.5, y: 4, w: 6.5, h: 6.5, fill:{color:SOLAR, transparency:80}, line:{type:"none"} });
s.addShape(p.ShapeType.ellipse, { x: -1.5, y: 5, w: 4.5, h: 4.5, fill:{color:SOLARBR, transparency:68}, line:{type:"none"} });
brand(s, true); pageno(s, 8);
kicker(s, "Gestalten wir es", SOLARBR, 2.4);
s.addText([{text:"SAUBER.\n", options:{color:ICE}}, {text:"FÜR IMMER.", options:{color:SOLARBR}}],
  { x: MX, y: 2.8, w: 11, h: 2.4, isTextBox:true, margin:0, fontFace:HEAD, fontSize:72, bold:true, lineSpacingMultiple:0.95 });
s.addText("Die Technik ist da, die Kosten fallen, die Zeit drängt. Jede Anlage, jede Entscheidung bringt uns näher ans Ziel.",
  { x: MX, y: 5.4, w: 8, h: 1, isTextBox:true, margin:0, fontFace:BODY, fontSize:16, color:ICEDIM, lineSpacingMultiple:1.3 });
s.addText("hallo@energiewende.de   ·   @energiewende", { x: MX, y: 6.5, w: 8, h: 0.4, isTextBox:true, margin:0, fontFace:BODY, fontSize:12, bold:true, color:ICEDIM, charSpacing:2 });
bar(s, true);

p.writeFile({ fileName: "/home/user/-/Erneuerbare-Energien.pptx" }).then(f => console.log("WROTE", f));
