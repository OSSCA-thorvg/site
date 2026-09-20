// The player applies this to authored Lua and to compiled JavaScript scenes.
// It changes presentation paint at object creation, after any model expression
// has resolved. Image/Cell samples, small pixel rectangles and their animation
// fills remain literal so a rendering example keeps its measured colors.

const factories = new Set(['group', 'space', 'text', 'line', 'arrow', 'vector', 'circle',
  'rectangle', 'polygon', 'plot', 'route', 'path', 'curve', 'surface', 'point',
  'ruler', 'svg', 'image', 'cell', 'connector']);
const motions = new Set(['play', 'stroke', 'fill']);

// Tokens retain source offsets; comments and strings cannot become API calls.
function tokens(source) {
  const result = [];
  const pattern = /--\[(=*)\[[\s\S]*?\]\1\]|--[^\n]*|\[(=*)\[[\s\S]*?\]\2\]|"(?:\\[\s\S]|[^"\\])*"|'(?:\\[\s\S]|[^'\\])*'|[A-Za-z_][A-Za-z_0-9]*|\s+|./g;
  for (const match of source.matchAll(pattern)) {
    const value = match[0];
    if (/^\s|^--/.test(value)) continue;
    result.push({value, start: match.index, end: match.index + value.length});
  }
  return result;
}

function closing(items, at) {
  const pairs = {'{': '}', '(': ')', '[': ']'};
  const stack = [];
  for (let i = at; i < items.length; i++) {
    const value = items[i].value;
    if (pairs[value]) stack.push(pairs[value]);
    else if (value === stack.at(-1)) {
      stack.pop();
      if (!stack.length) return i;
    }
  }
  return -1;
}

function receiverStart(items, before) {
  let at = before;
  if (items[at]?.value === ')' || items[at]?.value === ']') {
    const end = items[at].value, open = end === ')' ? '(' : '[';
    let depth = 1;
    while (--at >= 0) {
      if (items[at].value === end) depth++;
      if (items[at].value === open && --depth === 0) break;
    }
    if (at < 0) return -1;
    if (end === ']') at = receiverStart(items, at - 1);
  } else if (!/^[A-Za-z_][A-Za-z_0-9]*$/.test(items[at]?.value ?? '')) return -1;
  if (at > 1 && items[at - 1].value === '.') return receiverStart(items, at - 2);
  return at;
}

function normalizeColor(value) {
  if (typeof value !== 'string' || !/^#(?:[\da-f]{3}|[\da-f]{6})$/i.test(value)) {
    throw new TypeError('The animation palette must contain hex colors.');
  }
  if (value.length === 4) value = '#' + [...value.slice(1)].map(char => char + char).join('');
  return value.toLowerCase();
}

function helpers(palette) {
  const roles = ['background', 'foreground', 'muted', 'accent', 'secondary',
    'success', 'warning', 'danger', 'info', 'surface', 'line', 'result', 'focus'];
  const colors = roles.map(role => `${role}="${normalizeColor(palette[role])}"`).join(',');
  const objects = (palette.objects ?? [palette.info, palette.accent, palette.success])
    .map(color => `"${normalizeColor(color)}"`).join(',');
  return `-- OSSCA host theme: original geometry, fonts and clocks are retained.
local __osscaPalette={${colors},objects={${objects}}}
local __osscaMeta={}
local __osscaBoxes={}
local __osscaHues={
 ["2078dc"]="info",["1f66c4"]="info",["256ca8"]="info",["236caa"]="info",
 ["2769ac"]="info",["3274ad"]="info",["3579b5"]="info",["286ca8"]="info",
 ["d66b30"]="accent",["c76628"]="accent",["bc6728"]="accent",["cb6d2d"]="accent",
 ["c26a2c"]="accent",["c46a2a"]="accent",["bf692e"]="accent",
 ["23805c"]="success",["279a75"]="success",["28a06e"]="success",["387c76"]="success",
 ["8060b3"]="secondary",["7955a0"]="secondary",["7846aa"]="secondary",
 ["b4781e"]="warning",["b94a48"]="danger"
}
local function __osscaRGB(value)
 if type(value)~="string" then return nil end
 if string.sub(value,1,1)~="#" then return nil end
 local hex=string.sub(value,2)
 if #hex==3 or #hex==4 then
  local expanded=""
  for i=1,#hex do local c=string.sub(hex,i,i);expanded=expanded..c..c end
  hex=expanded
 end
 if #hex~=6 and #hex~=8 then return nil end
 local r,g,b=tonumber(string.sub(hex,1,2),16),tonumber(string.sub(hex,3,4),16),tonumber(string.sub(hex,5,6),16)
 if not r or not g or not b then return nil end
 return r,g,b,string.sub(hex,7,8),string.lower(string.sub(hex,1,6))
end
-- Pattern matching is deliberately unavailable in the tmath Lua sandbox.
local function __osscaContains(value,needle)
 for i=1,#value-#needle+1 do
  if string.sub(value,i,i+#needle-1)==needle then return true end
 end
 return false
end
local function __osscaNeutral(value)
 local r,g,b=__osscaRGB(value)
 return r and math.max(r,g,b)-math.min(r,g,b)<=(math.max(r,g,b)<140 and 48 or 32)
end
local function __osscaColor(value,channel)
 local r,g,b,alpha,hex=__osscaRGB(value)
 if not r or alpha=="00" then return value end
 -- White overlays are legibility outlines over literal images and pixels.
 if hex=="ffffff" and alpha~="" and alpha~="ff" then return value end
 local role=__osscaHues[hex]
 -- The postprocessing authors name this gray C.line, separate from C.ink.
 if channel=="stroke" and hex=="555555" then role="line" end
 if not role and __osscaNeutral(value) then
  local level=(r+g+b)/3
  if channel=="text" then
   role=level>215 and "background" or level>85 and "muted" or "foreground"
  elseif channel=="fill" then
   role=level>215 and "surface" or level>155 and "line" or level>85 and "muted" or "foreground"
  else
   role=level>155 and "line" or level>85 and "muted" or "foreground"
  end
 end
 return role and (__osscaPalette[role]..alpha) or value
end
local function __osscaScene(config)
 local theme=type(config.theme)=="table" and config.theme or {}
 theme.preset="adaptive_vscode"
 theme.background=__osscaPalette.background
 theme.objects=__osscaPalette.objects
 theme.text=theme.text or {}
 for _,role in ipairs({"h1","h2","h3","text","code"}) do
  theme.text[role]=theme.text[role] or {}
  theme.text[role].color=__osscaPalette.foreground
 end
 config.theme=theme
 if config.background then config.background=__osscaPalette.background end
 local scene=tmath.scene(config)
 __osscaMeta[scene]={scale=(config.height or 720)/((config.camera and config.camera.height) or 8)}
 return scene
end
local function __osscaEvidence(kind,config,scale)
 if kind=="image" or kind=="cell" or kind=="surface" then return true end
 -- A chromatic filled path is the Paint being explained; its fill and outline
 -- retain the same identity as the corresponding native rendered pixels.
 if kind=="path" or kind=="polygon" or kind=="svg" then
  local value=config.fill or config.color
  local r,_,_,alpha=__osscaRGB(value)
  if r and alpha~="00" and not __osscaNeutral(value) then return true end
 end
 if kind~="rectangle" then return false end
 local id=string.lower(config.id or "")
 if __osscaContains(id,"-pixel-") or __osscaContains(id,"_pixel_") or __osscaContains(id,"-texel-") or __osscaContains(id,"-committed-") or __osscaContains(id,"-computed-") or __osscaContains(id,"-swatch-") then return true end
 local size=config.size
 if not size then return false end
 local w,h=math.abs(size[1]*scale),math.abs(size[2]*scale)
 -- The native traces also contain grayscale coverage cells with generic IDs.
 if w<=80 and h<=80 and math.min(w,h)>0 and math.max(w,h)/math.min(w,h)<1.35 then return true end
 -- Color table entries and channel/coverage bars have no visible border.
 local _,_,_,alpha=__osscaRGB(config.stroke)
 if (config.layer or 0)>=20 and (config.width==0 or alpha=="00") then return true end
 return false
end
local function __osscaTextOnEvidence(parent,config)
 local point=config.point
 if not point then return false end
 local boxes=__osscaBoxes[parent] or {}
 for i=#boxes,1,-1 do
  local box=boxes[i]
  if (box.layer or 0)<(config.layer or 0) and math.abs(point[1]-box.center[1])<=box.size[1]/2 and math.abs(point[2]-box.center[2])<=box.size[2]/2 then
   return box.literal
  end
 end
 return false
end
local function __osscaObject(parent,kind,config)
 local scale=(__osscaMeta[parent] or {}).scale or 1
 local evidence=__osscaEvidence(kind,config,scale)
 local literalText=kind=="text" and __osscaTextOnEvidence(parent,config)
 local _,_,_,fillAlpha=__osscaRGB(config.fill)
 if kind=="rectangle" and config.center and config.size and config.fill and fillAlpha~="00" then
  local boxes=__osscaBoxes[parent] or {}
  boxes[#boxes+1]={center=config.center,size=config.size,layer=config.layer,literal=evidence or (config.fill and not __osscaNeutral(config.fill) and not __osscaHues[string.sub(config.fill,2,7)])}
  __osscaBoxes[parent]=boxes
 end
 if kind~="image" and kind~="cell" and kind~="surface" then
  if config.stroke and not evidence then config.stroke=__osscaColor(config.stroke,"stroke") end
  if kind=="text" then
   if not literalText then
    if config.fill then config.fill=__osscaColor(config.fill,"text") end
    if config.color then config.color=__osscaColor(config.color,"text") end
   end
  elseif not evidence then
   if config.fill then config.fill=__osscaColor(config.fill,"fill") end
   if config.color then config.color=__osscaColor(config.color,"fill") end
  end
 end
 local object=parent[kind](parent,config)
 __osscaMeta[object]={scale=scale,evidence=evidence,literalText=literalText,kind=kind}
 return object
end
local function __osscaMotion(parent,kind,...)
 local args={...}
 local function paint(target,color,channel)
  local meta=__osscaMeta[target]
  if not meta or meta.evidence or meta.literalText then return color end
  return __osscaColor(color,meta.kind=="text" and "text" or channel)
 end
 if kind=="play" then
  local descriptor=args[1]
  local clips=descriptor.target and {descriptor} or descriptor
  for _,clip in ipairs(clips) do
   if clip.fill then clip.fill=paint(clip.target,clip.fill,"fill") end
   if clip.stroke then clip.stroke=paint(clip.target,clip.stroke,"stroke") end
  end
 else args[2]=paint(args[1],args[2],kind) end
 return parent[kind](parent,table.unpack(args))
end
`;
}

/**
 * Apply the current host palette to presentation objects in a scene source.
 * Palette values follow HostThemePalette from runtime/client.d.ts. The caller
 * must retain the original source when reloading after a theme change.
 */
export function themeLua(source, palette) {
  const items = tokens(source), edits = [];
  for (let i = 0; i < items.length; i++) {
    if (items[i].value === 'tmath' && items[i + 1]?.value === '.' && items[i + 2]?.value === 'scene') {
      edits.push({start: items[i].start, end: items[i + 2].end, value: '__osscaScene'});
      continue;
    }
    if (items[i].value !== ':') continue;
    const kind = items[i + 1]?.value;
    if (!factories.has(kind) && !motions.has(kind)) continue;
    const start = receiverStart(items, i - 1);
    if (start < 0) continue;
    const open = i + 2, token = items[open]?.value;
    if (token !== '{' && token !== '(') continue;
    const end = closing(items, open);
    if (end < 0) continue;
    const receiver = source.slice(items[start].start, items[i - 1].end);
    const args = token === '{'
      ? source.slice(items[open].start, items[end].end)
      : source.slice(items[open].end, items[end].start);
    const helper = factories.has(kind) ? '__osscaObject' : '__osscaMotion';
    edits.push({start: items[start].start, end: items[end].end, value: `${helper}(${receiver},"${kind}",${args})`});
    i = end;
  }
  for (let i = edits.length - 1; i >= 0; i--) {
    const edit = edits[i];
    source = source.slice(0, edit.start) + edit.value + source.slice(edit.end);
  }
  return helpers(palette) + source;
}
