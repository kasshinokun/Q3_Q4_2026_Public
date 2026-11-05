const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");
const fa = require("react-icons/fa");
const THEME = { name: "PetCuida", headFontFace: "Cambria", bodyFontFace: "Calibri",
  colors: { dk1:"1B2B30", lt1:"FFFFFF", dk2:"0F4C5C", lt2:"EAF4F4", accent1:"F26B5B", accent2:"2A9D8F",
    accent3:"F4A261", accent4:"264653", accent5:"8AB6B8", accent6:"E9C46A", hlink:"0F4C5C", folHlink:"264653" } };
const K = { teal:"0F4C5C", tealMid:"2A9D8F", coral:"F26B5B", amber:"F4A261", ink:"1B2B30", tint:"EAF4F4", white:"FFFFFF", muted:"5B6F75", pale:"8AB6B8", deep:"264653" };
async function icon(name, color, size=256) {
  const svg = ReactDOMServer.renderToStaticMarkup(React.createElement(fa[name], { color: "#"+color, size: String(size) }));
  const buf = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + buf.toString("base64");
}
function setupMasters(pres) {
  pres.layout = "LAYOUT_WIDE";
  pres.theme = { headFontFace: THEME.headFontFace, bodyFontFace: THEME.bodyFontFace };
  pres.defineSlideMaster({ title:"LIGHT", background:{color:K.white},
    objects:[{ placeholder:{ options:{ name:"title", type:"title", x:0.6, y:0.35, w:12.1, h:1.1, fontFace:"Cambria", fontSize:36, bold:true, color:K.teal, align:"left", valign:"middle", margin:0 }, text:"" } }],
    slideNumber:{ x:12.3, y:7.0, w:0.6, h:0.3, color:K.muted, fontSize:12 } });
  pres.defineSlideMaster({ title:"DARK", background:{color:K.teal},
    objects:[{ placeholder:{ options:{ name:"title", type:"title", x:0.6, y:0.35, w:12.1, h:1.1, fontFace:"Cambria", fontSize:36, bold:true, color:K.white, align:"left", valign:"middle", margin:0 }, text:"" } }],
    slideNumber:{ x:12.3, y:7.0, w:0.6, h:0.3, color:K.pale, fontSize:12 } });
  pres.defineSlideMaster({ title:"COVER", background:{color:K.teal},
    objects:[{ placeholder:{ options:{ name:"title", type:"title", x:0.8, y:1.5, w:7.6, h:2.3, fontFace:"Cambria", fontSize:48, bold:true, color:K.white, align:"left", valign:"top", margin:0 }, text:"" } }] });
}
function src(slide, text, dark=false) {
  slide.addText(text, { x:0.6, y:6.95, w:11.4, h:0.35, fontSize:11, color: dark?K.pale:K.muted, margin:0, isTextBox:true, objectName:"Fonte" });
}
module.exports = { THEME, K, icon, setupMasters, src };
