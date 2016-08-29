---
layout: post
title: Ist der Himmel nachts häufiger klar?
excerpt: Diese Frage soll auf interaktive Weise durch Daten beantwortet werden
category: showcase
language: German
author: Nanu Frechen
bootstrap: true
D3js: true
datasource: <a href="http://www.dwd.de/DE/klimaumwelt/cdc/cdc_node.html">Deutscher Wetterdienst</a>
technique: <a href="http://r-project.org">R</a>, <a href="http://d3js.org">D3js</a>, <a href="https://cran.r-project.org/web/packages/astrolibR/index.html">astrolibR</a>, <a href="https://github.com/nFrechen/RgetDWDdata">RgetDWDdata</a>
---

<style>
#Monatswerte{
  border: 1px solid #ddd;
  border-radius: 7px;
  padding: 5px 5px;
}
ul, ol{
  margin-left: 0px;
}
.nav > li > a {
    padding: 1px 6px;
}
#Bedeckungsgrad{
  background-image: url('/images/Monatliche_Bedeckung/Bedeckungsgrad.svg');
  background-size: 100% auto;
  background-repeat: none;
}
.ExplainPlot{
  padding: 0;
}
svg {
  width: 100%;
  
  height: auto;
}
</style>




# Die Fragestellung

Kennen Sie das Phänomen: Sie schauen nach dem Aufwachen aus dem Fenster und erblicken einen strahlend blauen Himmel. Sie freuen sich also auf einen sonnigen Tag! Aber als Sie nach dem Duschen und dem Frühstück das Haus verlassen, ist der Himmel schon wieder zugezogen und die Sonne scheint nicht so, wie sie das erwartet haben. Also die Frage: **"Kann es sein, dass wir in der Nacht und in den Morgenstunden häufiger klaren Himmel haben als tagsüber?"**. 



Um diese Frage zu beantworten bieten sich ein [Datensatz des Deutschen Wetterdienstes (DWD)](http://www.dwd.de/DE/klimaumwelt/cdc/cdc_node.html) an:
Der Deutsche Wetterdienst unterscheidet neun Stufen des Bedeckungsgrades, die von 0 (keine Bedeckung) bis 8 (vollständige Bedeckung) reichen. Diese werden in stündlichen Intervallen aufgezeichnet. 
Deutschlandweit werden 324 Stationen betrieben, die auf diese Weise den Bedeckungsgrad aufzeichnen. Wir wollen uns die Daten der Station Cottbus anschauen.

Wir wollen uns nun anschauen, wie häufig die neun Stufen des Bedeckungsgrades zwischen 0 und 24 Uhr gemessen wurden. Dazu erzeugen wir ein Raster aus 9 mal 24 Kästschen. Die Farbe der Kästschen definieren wir nach der Anzahl der Messwerte, die in diesem Kästschen liegen (zum Beispiel im <a data-toggle="tab" href="#Beispiel" onmouseover="highlight('none')">Kästchen zum Bedeckungsgrad 3 im Zeitraum zwischen Stunde 8 und 9</a>).















# Was zeigt die Statistik?









<div>
  <div class="col-sm-4 ExplainPlot">
    <ul id="Bedeckung_nav" class="nav
    nav-stacked">
      <li><a data-toggle="tab" href="#maximum" onmouseover="highlight('maximumLine')">Wenn es maximal bewölkt ist, macht es keinen Unterschied, ob es Tag oder Nacht ist.</a></li>
      <li><a data-toggle="tab" href="#Nacht" onmouseover="highlight('KlarLine')">Nachts ist die Wahrscheinlichkeit, dass der Himmel völlig klar ist wesentlich höher als tagsüber.</a></li>
      <li><a data-toggle="tab" href="#Tag_stark_bedeckt" onmouseover="highlight('starkLine')">Ein Bedeckungsgrad der Stufe 7 ist tagsüber wahrscheinlicher als nachts.</a></li>
      <li><a data-toggle="tab" href="#Tag" onmouseover="highlight('none')">Tagsüber sind geringe Bedeckungsgrade zwischen 0 und 5 ungefähr gleich wahrscheinlich.</a></li>
      <li><a data-toggle="tab" href="#Mittelbereich" onmouseover="highlight('MittelLine')">Bedeckungsgrade von 1 bis 6 unterscheiden sich in ihrer Häufigkeit nicht groß zwischen Tag und Nacht.</a></li>
    </ul>
  </div>
  <div id="Bedeckung_Jahr" class="tab-content col-sm-8">
    <div id="base" class="tab-pane active">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad.svg"/>
    </div>
    <div id="maximum" class="tab-pane">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad_maximal.svg"/>
    </div>
    <div id="Nacht" class="tab-pane">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad_Nacht_klar.svg"/>
    </div>
    <div id="Tag_stark_bedeckt" class="tab-pane">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad_Tag_stark_bedeckt.svg"/>
    </div>
    <div id="Tag" class="tab-pane">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad_Tag.svg"/>
    </div>
    <div id="Mittelbereich" class="tab-pane">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad_Mittelbereich.svg"/>
    </div>
    <div id="Beispiel" class="tab-pane">
      <img id="Bedeckungsgrad" src="/images/Monatliche_Bedeckung/Bedeckungsgrad_Beispiel.svg"/>
    </div>
    <div id="Line-plot">
<?xml version="1.0" encoding="UTF-8" standalone="no"?> <svg 
   xmlns:dc="http://purl.org/dc/elements/1.1/" 
   xmlns:cc="http://creativecommons.org/ns#" 
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
   xmlns:svg="http://www.w3.org/2000/svg" 
   xmlns="http://www.w3.org/2000/svg" 
   xmlns:xlink="http://www.w3.org/1999/xlink" 
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd" 
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape" 
   viewBox="0 0 504 288"    version="1.1"    id="svg4820" 
   inkscape:version="0.91+devel+osxmenu r12922" 
   sodipodi:docname="Line-plot-scriptable.svg"    height="100%" 
   width="100%"    preserveAspectRatio="xMinYMinMeet">   <metadata 
     id="metadata5235">     <rdf:RDF>       <cc:Work 
         rdf:about="">         <dc:format>image/svg+xml</dc:format> 
        <dc:type 
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" /> 
        <dc:title></dc:title>       </cc:Work>     </rdf:RDF> 
  </metadata>   <sodipodi:namedview      pagecolor="#ffffff" 
     bordercolor="#666666"      borderopacity="1" 
     objecttolerance="10"      gridtolerance="10" 
     guidetolerance="10"      inkscape:pageopacity="0" 
     inkscape:pageshadow="2"      inkscape:window-width="1280" 
     inkscape:window-height="751"      id="namedview5233" 
     showgrid="false"      inkscape:zoom="1.6709607" 
     inkscape:cx="200.58438"      inkscape:cy="192.59846" 
     inkscape:window-x="0"      inkscape:window-y="23" 
     inkscape:window-maximized="0" 
     inkscape:current-layer="g5179-1" />   <defs      id="defs4822"> 
    <g        id="g4824">       <symbol          overflow="visible" 
         id="glyph0-0"          style="overflow:visible"> 
        <path            style="stroke:none" 
           d="m 0.390625,0 0,-8.609375 6.828125,0 0,8.609375 z m 5.75,-1.078125 0,-6.453125 -4.671875,0 0,6.453125 z" 
           id="path4827" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-1" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 3.25,-8.390625 c 1.082031,0 1.867188,0.449219 2.359375,1.34375 0.375,0.6875 0.5625,1.636719 0.5625,2.84375 C 6.171875,-3.066406 6,-2.125 5.65625,-1.375 5.164062,-0.300781 4.359375,0.234375 3.234375,0.234375 c -1,0 -1.75,-0.4375 -2.25,-1.3125 C 0.578125,-1.816406 0.375,-2.800781 0.375,-4.03125 c 0,-0.945312 0.125,-1.765625 0.375,-2.453125 0.457031,-1.269531 1.289062,-1.90625 2.5,-1.90625 z m -0.015625,7.65625 c 0.550781,0 0.988281,-0.238281 1.3125,-0.71875 0.320313,-0.488281 0.484375,-1.394531 0.484375,-2.71875 0,-0.945313 -0.121094,-1.726563 -0.359375,-2.34375 C 4.441406,-7.128906 3.988281,-7.4375 3.3125,-7.4375 c -0.625,0 -1.085938,0.292969 -1.375,0.875 -0.28125,0.585938 -0.421875,1.445312 -0.421875,2.578125 0,0.855469 0.09375,1.542969 0.28125,2.0625 0.28125,0.792969 0.757813,1.1875 1.4375,1.1875 z" 
           id="path4830" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-2" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="M 0.375,0 C 0.414062,-0.71875 0.566406,-1.34375 0.828125,-1.875 1.085938,-2.414062 1.59375,-2.90625 2.34375,-3.34375 L 3.46875,-4 c 0.5,-0.289062 0.851562,-0.539062 1.0625,-0.75 0.320312,-0.320312 0.484375,-0.691406 0.484375,-1.109375 0,-0.488281 -0.152344,-0.875 -0.453125,-1.15625 -0.292969,-0.289063 -0.679688,-0.4375 -1.15625,-0.4375 -0.730469,0 -1.230469,0.273437 -1.5,0.8125 -0.15625,0.304687 -0.242188,0.710937 -0.25,1.21875 l -1.078125,0 c 0.007813,-0.726563 0.144531,-1.320313 0.40625,-1.78125 0.457031,-0.8125 1.265625,-1.21875 2.421875,-1.21875 0.957031,0 1.65625,0.261719 2.09375,0.78125 0.445312,0.523437 0.671875,1.101563 0.671875,1.734375 0,0.667969 -0.234375,1.242188 -0.703125,1.71875 C 5.195312,-3.90625 4.707031,-3.566406 4,-3.171875 l -0.8125,0.4375 C 2.8125,-2.523438 2.515625,-2.320312 2.296875,-2.125 1.898438,-1.789062 1.648438,-1.414062 1.546875,-1 l 4.59375,0 0,1 z" 
           id="path4833" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-3" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 3.96875,-2.96875 0,-3.8125 -2.6875,3.8125 z M 3.984375,0 l 0,-2.046875 -3.671875,0 0,-1.03125 3.84375,-5.34375 0.890625,0 0,5.453125 1.234375,0 0,0.921875 -1.234375,0 0,2.046875 z" 
           id="path4836" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-4" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 3.515625,-8.421875 c 0.9375,0 1.585937,0.246094 1.953125,0.734375 0.375,0.480469 0.5625,0.980469 0.5625,1.5 l -1.046875,0 C 4.921875,-6.519531 4.820312,-6.78125 4.6875,-6.96875 4.425781,-7.320312 4.039062,-7.5 3.53125,-7.5 c -0.59375,0 -1.070312,0.277344 -1.421875,0.828125 -0.34375,0.542969 -0.53125,1.320313 -0.5625,2.328125 0.238281,-0.351562 0.539063,-0.617188 0.90625,-0.796875 0.332031,-0.15625 0.707031,-0.234375 1.125,-0.234375 0.707031,0 1.320313,0.226562 1.84375,0.671875 0.519531,0.449219 0.78125,1.121094 0.78125,2.015625 0,0.761719 -0.25,1.4375 -0.75,2.03125 -0.492187,0.5859375 -1.195313,0.875 -2.109375,0.875 -0.792969,0 -1.476562,-0.296875 -2.046875,-0.890625 -0.5625,-0.601563 -0.84375,-1.609375 -0.84375,-3.015625 0,-1.039062 0.125,-1.925781 0.375,-2.65625 0.488281,-1.382812 1.382813,-2.078125 2.6875,-2.078125 z M 3.4375,-0.71875 c 0.550781,0 0.960938,-0.1875 1.234375,-0.5625 0.28125,-0.375 0.421875,-0.816406 0.421875,-1.328125 0,-0.425781 -0.125,-0.832031 -0.375,-1.21875 C 4.476562,-4.210938 4.03125,-4.40625 3.375,-4.40625 c -0.449219,0 -0.84375,0.152344 -1.1875,0.453125 -0.34375,0.292969 -0.515625,0.742187 -0.515625,1.34375 0,0.53125 0.15625,0.980469 0.46875,1.34375 0.3125,0.367187 0.742187,0.546875 1.296875,0.546875 z" 
           id="path4839" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-5" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 3.265625,-4.875 c 0.46875,0 0.832031,-0.128906 1.09375,-0.390625 C 4.617188,-5.523438 4.75,-5.832031 4.75,-6.1875 4.75,-6.5 4.625,-6.785156 4.375,-7.046875 c -0.25,-0.269531 -0.632812,-0.40625 -1.140625,-0.40625 -0.511719,0 -0.882813,0.136719 -1.109375,0.40625 -0.230469,0.261719 -0.34375,0.5625 -0.34375,0.90625 0,0.398437 0.144531,0.710937 0.4375,0.9375 0.300781,0.21875 0.648438,0.328125 1.046875,0.328125 z m 0.0625,4.15625 c 0.488281,0 0.894531,-0.128906 1.21875,-0.390625 0.320313,-0.269531 0.484375,-0.664063 0.484375,-1.1875 0,-0.539063 -0.167969,-0.953125 -0.5,-1.234375 C 4.195312,-3.8125 3.769531,-3.953125 3.25,-3.953125 c -0.5,0 -0.914062,0.148437 -1.234375,0.4375 -0.3125,0.28125 -0.46875,0.679687 -0.46875,1.1875 0,0.4375 0.144531,0.820313 0.4375,1.140625 0.289063,0.3125 0.738281,0.46875 1.34375,0.46875 z m -1.5,-3.75 C 1.535156,-4.59375 1.304688,-4.738281 1.140625,-4.90625 0.835938,-5.21875 0.6875,-5.625 0.6875,-6.125 c 0,-0.625 0.222656,-1.160156 0.671875,-1.609375 0.457031,-0.457031 1.097656,-0.6875 1.921875,-0.6875 0.8125,0 1.441406,0.214844 1.890625,0.640625 0.457031,0.429688 0.6875,0.921875 0.6875,1.484375 0,0.523437 -0.132813,0.949219 -0.390625,1.28125 -0.148438,0.179687 -0.375,0.355469 -0.6875,0.53125 0.34375,0.15625 0.613281,0.339844 0.8125,0.546875 0.375,0.398438 0.5625,0.90625 0.5625,1.53125 0,0.742188 -0.25,1.367188 -0.75,1.875 -0.492188,0.5117188 -1.1875,0.765625 -2.09375,0.765625 -0.824219,0 -1.515625,-0.21875 -2.078125,-0.65625 -0.5625,-0.445313 -0.84375,-1.09375 -0.84375,-1.9375 0,-0.488281 0.117187,-0.914063 0.359375,-1.28125 0.238281,-0.363281 0.597656,-0.640625 1.078125,-0.828125 z" 
           id="path4842" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-6" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 1.15625,-5.9375 0,-0.8125 c 0.757812,-0.070312 1.285156,-0.195312 1.578125,-0.375 0.300781,-0.175781 0.53125,-0.585938 0.6875,-1.234375 l 0.828125,0 L 4.25,0 3.125,0 l 0,-5.9375 z" 
           id="path4845" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-7" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 1.03125,-1.28125 1.21875,0 L 2.25,0 1.03125,0 Z" 
           id="path4848" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-8" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 1.484375,-2.140625 c 0.070313,0.605469 0.351563,1.023437 0.84375,1.25 0.25,0.117187 0.535156,0.171875 0.859375,0.171875 0.625,0 1.085938,-0.195312 1.390625,-0.59375 C 4.878906,-1.707031 5.03125,-2.148438 5.03125,-2.640625 5.03125,-3.222656 4.847656,-3.675781 4.484375,-4 4.128906,-4.320312 3.703125,-4.484375 3.203125,-4.484375 c -0.367187,0 -0.679687,0.074219 -0.9375,0.21875 C 2.003906,-4.128906 1.785156,-3.9375 1.609375,-3.6875 L 0.6875,-3.734375 1.328125,-8.25 l 4.359375,0 0,1.015625 -3.5625,0 -0.359375,2.328125 c 0.195313,-0.144531 0.382813,-0.253906 0.5625,-0.328125 0.3125,-0.125 0.671875,-0.1875 1.078125,-0.1875 0.769531,0 1.421875,0.25 1.953125,0.75 0.539063,0.492187 0.8125,1.117187 0.8125,1.875 0,0.792969 -0.25,1.496094 -0.75,2.109375 -0.492187,0.6054688 -1.273437,0.90625 -2.34375,0.90625 -0.679687,0 -1.28125,-0.1953125 -1.8125,-0.578125 -0.523437,-0.382813 -0.8125,-0.976563 -0.875,-1.78125 z" 
           id="path4851" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-9" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 2.1875,-8.609375 0,5.328125 c 0,0.625 0.113281,1.140625 0.34375,1.546875 0.34375,0.625 0.929688,0.9375 1.765625,0.9375 0.976563,0 1.648437,-0.335937 2.015625,-1.015625 C 6.5,-2.175781 6.59375,-2.664062 6.59375,-3.28125 l 0,-5.328125 1.1875,0 0,4.828125 c 0,1.0625 -0.148438,1.882812 -0.4375,2.453125 -0.523438,1.042969 -1.507812,1.5625 -2.953125,1.5625 -1.460937,0 -2.449219,-0.519531 -2.96875,-1.5625 C 1.140625,-1.898438 1,-2.71875 1,-3.78125 l 0,-4.828125 z m 2.203125,0 z" 
           id="path4854" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-10" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 0.78125,-8.640625 1.046875,0 0,3.21875 C 2.078125,-5.742188 2.300781,-5.96875 2.5,-6.09375 2.84375,-6.3125 3.269531,-6.421875 3.78125,-6.421875 c 0.90625,0 1.519531,0.320313 1.84375,0.953125 0.175781,0.34375 0.265625,0.824219 0.265625,1.4375 l 0,4.03125 -1.078125,0 0,-3.953125 C 4.8125,-4.410156 4.75,-4.75 4.625,-4.96875 4.4375,-5.3125 4.078125,-5.484375 3.546875,-5.484375 c -0.4375,0 -0.835937,0.152344 -1.1875,0.453125 -0.355469,0.304688 -0.53125,0.871094 -0.53125,1.703125 L 1.828125,0 0.78125,0 Z" 
           id="path4857" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-11" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 0.796875,-6.28125 1.015625,0 0,1.09375 c 0.070312,-0.21875 0.269531,-0.476562 0.59375,-0.78125 0.320312,-0.300781 0.691406,-0.453125 1.109375,-0.453125 0.019531,0 0.050781,0.00781 0.09375,0.015625 0.050781,0 0.132813,0.00781 0.25,0.015625 l 0,1.109375 C 3.796875,-5.28906 3.738281,-5.296875 3.6875,-5.296875 c -0.054688,0 -0.109375,0 -0.171875,0 -0.53125,0 -0.945313,0.171875 -1.234375,0.515625 C 2,-4.445312 1.859375,-4.054688 1.859375,-3.609375 l 0,3.609375 -1.0625,0 z" 
           id="path4860" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-12" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 0.3125,-0.828125 3.71875,-4.5 -3.453125,0 0,-0.953125 4.859375,0 0,0.859375 -3.6875,4.484375 3.8125,0 0,0.9375 -5.25,0 z m 2.703125,-5.59375 z" 
           id="path4863" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-13" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 3.390625,-6.421875 c 0.445313,0 0.878906,0.105469 1.296875,0.3125 0.414062,0.210937 0.734375,0.480469 0.953125,0.8125 0.207031,0.324219 0.347656,0.695313 0.421875,1.109375 0.0625,0.292969 0.09375,0.757812 0.09375,1.390625 l -4.609375,0 C 1.566406,-2.160156 1.71875,-1.648438 2,-1.265625 2.28125,-0.878906 2.71875,-0.6875 3.3125,-0.6875 c 0.550781,0 0.988281,-0.179688 1.3125,-0.546875 C 4.8125,-1.441406 4.945312,-1.6875 5.03125,-1.96875 l 1.03125,0 C 6.039062,-1.738281 5.953125,-1.484375 5.796875,-1.203125 5.640625,-0.921875 5.46875,-0.6875 5.28125,-0.5 4.957031,-0.1875 4.554688,0.0195312 4.078125,0.125 3.828125,0.1875 3.539062,0.21875 3.21875,0.21875 2.4375,0.21875 1.773438,-0.0625 1.234375,-0.625 c -0.542969,-0.570312 -0.8125,-1.367188 -0.8125,-2.390625 0,-1.007813 0.269531,-1.828125 0.8125,-2.453125 0.550781,-0.632812 1.269531,-0.953125 2.15625,-0.953125 z M 5.0625,-3.640625 C 5.019531,-4.097656 4.921875,-4.460938 4.765625,-4.734375 4.484375,-5.242188 4.003906,-5.5 3.328125,-5.5 2.835938,-5.5 2.425781,-5.320312 2.09375,-4.96875 1.769531,-4.625 1.597656,-4.179688 1.578125,-3.640625 Z m -1.78125,-2.78125 z" 
           id="path4866" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-14" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 0.78125,-6.25 1.0625,0 0,6.25 -1.0625,0 z m 0,-2.359375 1.0625,0 0,1.203125 -1.0625,0 z" 
           id="path4869" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph0-15" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 0.984375,-8.03125 1.0625,0 0,1.75 1,0 0,0.859375 -1,0 0,4.109375 c 0,0.21875 0.078125,0.367188 0.234375,0.4375 0.070312,0.042969 0.207031,0.0625 0.40625,0.0625 0.050781,0 0.101562,0 0.15625,0 0.0625,-0.007812 0.128906,-0.015625 0.203125,-0.015625 L 3.046875,0 C 2.929688,0.03125 2.804688,0.0507812 2.671875,0.0625 2.546875,0.0820312 2.40625,0.09375 2.25,0.09375 c -0.492188,0 -0.824219,-0.125 -1,-0.375 -0.179688,-0.25 -0.265625,-0.578125 -0.265625,-0.984375 l 0,-4.15625 -0.84375,0 0,-0.859375 0.84375,0 z" 
           id="path4872" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-0" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m 0,-0.390625 -8.609375,0 0,-6.828125 8.609375,0 z m -1.078125,-5.75 -6.453125,0 0,4.671875 6.453125,0 z" 
           id="path4875" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-1" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -8.609375,-0.9375 0,-1.1875 3.5625,0 0,-4.46875 -3.5625,0 0,-1.1875 8.609375,0 0,1.1875 -4.03125,0 0,4.46875 4.03125,0 0,1.1875 z" 
           id="path4878" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-2" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -1.671875,-1.578125 c 0.304687,0 0.542969,-0.109375 0.71875,-0.328125 0.179687,-0.226562 0.265625,-0.492188 0.265625,-0.796875 0,-0.375 -0.082031,-0.734375 -0.25,-1.078125 -0.289062,-0.59375 -0.757812,-0.890625 -1.40625,-0.890625 l -0.84375,0 c 0.074219,0.136719 0.140625,0.308594 0.203125,0.515625 0.054687,0.199219 0.089844,0.398438 0.109375,0.59375 l 0.078125,0.625 c 0.054687,0.386719 0.136719,0.679688 0.25,0.875 0.179687,0.324219 0.46875,0.484375 0.875,0.484375 z m -2.125,-2.5625 c -0.03125,-0.238281 -0.132813,-0.398437 -0.3125,-0.484375 -0.09375,-0.039062 -0.226563,-0.0625 -0.40625,-0.0625 -0.351563,0 -0.609375,0.132812 -0.765625,0.390625 -0.164062,0.25 -0.25,0.609375 -0.25,1.078125 0,0.554688 0.148438,0.945312 0.4375,1.171875 0.167969,0.136719 0.414062,0.226563 0.734375,0.265625 l 0,0.984375 c -0.769531,-0.019531 -1.304687,-0.269531 -1.609375,-0.75 -0.300781,-0.488281 -0.453125,-1.050781 -0.453125,-1.6875 0,-0.738281 0.140625,-1.335937 0.421875,-1.796875 0.28125,-0.457031 0.71875,-0.6875 1.3125,-0.6875 l 3.609375,0 c 0.105469,0 0.195313,-0.019531 0.265625,-0.0625 0.0625,-0.050781 0.09375,-0.148438 0.09375,-0.296875 0,-0.039063 0,-0.085937 0,-0.140625 -0.007812,-0.0625 -0.019531,-0.128906 -0.03125,-0.203125 l 0.78125,0 c 0.0390625,0.167969 0.0664062,0.296875 0.078125,0.390625 0.019531,0.085938 0.03125,0.199219 0.03125,0.34375 0,0.367188 -0.1328125,0.625 -0.390625,0.78125 -0.132812,0.09375 -0.328125,0.15625 -0.578125,0.1875 0.28125,0.21875 0.527344,0.53125 0.734375,0.9375 0.207031,0.398438 0.3125,0.835938 0.3125,1.3125 0,0.585938 -0.1796875,1.0625 -0.53125,1.4375 -0.351562,0.367188 -0.796875,0.546875 -1.328125,0.546875 -0.582031,0 -1.035156,-0.179687 -1.359375,-0.546875 -0.320312,-0.363281 -0.519531,-0.835938 -0.59375,-1.421875 z m -2.625,0.875 z m -2.046875,-0.5625 0,-1.09375 1.21875,0 0,1.09375 z m 0,1.9375 0,-1.09375 1.21875,0 0,1.09375 z" 
           id="path4881" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-3" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -6.28125,-1.828125 4.171875,0 c 0.324219,0 0.585937,-0.050781 0.78125,-0.15625 0.375,-0.1875 0.5625,-0.535156 0.5625,-1.046875 0,-0.726562 -0.328125,-1.226562 -0.984375,-1.5 C -2.101562,-4.675781 -2.582031,-4.75 -3.1875,-4.75 l -3.09375,0 0,-1.046875 6.28125,0 0,0.984375 -0.921875,0 c 0.242187,0.136719 0.4375,0.304688 0.59375,0.5 0.33203125,0.40625 0.5,0.898438 0.5,1.46875 0,0.898438 -0.300781,1.507812 -0.90625,1.828125 -0.3125,0.179687 -0.738281,0.265625 -1.28125,0.265625 l -4.265625,0 z M -6.421875,-3.28125 Z" 
           id="path4884" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-4" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -7.234375,-1.03125 c -0.4375,-0.019531 -0.753906,-0.097656 -0.953125,-0.234375 -0.363281,-0.25 -0.546875,-0.722656 -0.546875,-1.421875 0,-0.070312 0.00781,-0.140625 0.015625,-0.203125 0,-0.070313 0.00781,-0.15625 0.015625,-0.25 l 0.953125,0 c -0.00781,0.117187 -0.015625,0.199219 -0.015625,0.25 0,0.042969 0,0.085937 0,0.125 0,0.324219 0.085937,0.515625 0.25,0.578125 0.167969,0.0625 0.589844,0.09375 1.265625,0.09375 l 0,-1.046875 0.828125,0 0,1.0625 5.421875,0 0,1.046875 -5.421875,0 0,0.859375 -0.828125,0 0,-0.859375 z" 
           id="path4887" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-5" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -6.25,-0.78125 0,-1.0625 6.25,0 0,1.0625 z m -2.359375,0 0,-1.0625 1.203125,0 0,1.0625 z" 
           id="path4890" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-6" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -6.390625,-2.984375 c 0,-0.5 0.121094,-0.929687 0.359375,-1.296875 0.148438,-0.195312 0.351562,-0.398438 0.609375,-0.609375 l -0.796875,0 0,-0.96875 5.703125,0 c 0.800781,0 1.429687,0.117187 1.890625,0.34375 0.851562,0.4375 1.28125,1.265625 1.28125,2.484375 0,0.679688 -0.152344,1.246094 -0.453125,1.703125 -0.304687,0.460937 -0.777344,0.71875 -1.421875,0.78125 l 0,-1.078125 c 0.28125,-0.050781 0.5,-0.148438 0.65625,-0.296875 0.226562,-0.238281 0.34375,-0.613281 0.34375,-1.125 0,-0.8125 -0.289062,-1.34375 -0.859375,-1.59375 C 0.585938,-4.785156 -0.0078125,-4.851562 -0.875,-4.84375 c 0.324219,0.210938 0.5625,0.464844 0.71875,0.765625 0.15625,0.292969 0.234375,0.683594 0.234375,1.171875 0,0.679688 -0.238281,1.273438 -0.71875,1.78125 -0.488281,0.511719 -1.289063,0.765625 -2.40625,0.765625 -1.050781,0 -1.867187,-0.253906 -2.453125,-0.765625 -0.59375,-0.519531 -0.890625,-1.140625 -0.890625,-1.859375 z m 3.21875,-1.90625 c -0.769531,0 -1.34375,0.164063 -1.71875,0.484375 -0.375,0.324219 -0.5625,0.730469 -0.5625,1.21875 0,0.75 0.351563,1.261719 1.046875,1.53125 0.367188,0.148438 0.851562,0.21875 1.453125,0.21875 0.710937,0 1.25,-0.140625 1.625,-0.421875 0.367187,-0.289063 0.546875,-0.679687 0.546875,-1.171875 0,-0.757812 -0.34375,-1.289062 -1.03125,-1.59375 -0.382812,-0.175781 -0.835938,-0.265625 -1.359375,-0.265625 z m -3.25,1.78125 z" 
           id="path4893" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-7" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -8.609375,-0.75 0,-1.015625 5,0 -2.671875,-2.703125 0,-1.34375 2.359375,2.390625 L 0,-5.953125 l 0,1.34375 -3.171875,1.953125 0.8125,0.890625 2.359375,0 L 0,-0.75 Z" 
           id="path4896" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-8" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -6.421875,-3.390625 c 0,-0.445313 0.105469,-0.878906 0.3125,-1.296875 0.210937,-0.414062 0.480469,-0.734375 0.8125,-0.953125 0.324219,-0.207031 0.695313,-0.347656 1.109375,-0.421875 0.292969,-0.0625 0.757812,-0.09375 1.390625,-0.09375 l 0,4.609375 C -2.160156,-1.566406 -1.648438,-1.71875 -1.265625,-2 -0.878906,-2.28125 -0.6875,-2.71875 -0.6875,-3.3125 c 0,-0.550781 -0.179688,-0.988281 -0.546875,-1.3125 C -1.441406,-4.8125 -1.6875,-4.945312 -1.96875,-5.03125 l 0,-1.03125 c 0.230469,0.023438 0.484375,0.109375 0.765625,0.265625 0.28125,0.15625 0.515625,0.328125 0.703125,0.515625 0.3125,0.324219 0.5195312,0.726562 0.625,1.203125 0.0625,0.25 0.09375,0.539063 0.09375,0.859375 0,0.78125 -0.28125,1.445312 -0.84375,1.984375 -0.570312,0.542969 -1.367188,0.8125 -2.390625,0.8125 -1.007813,0 -1.828125,-0.269531 -2.453125,-0.8125 -0.632812,-0.550781 -0.953125,-1.269531 -0.953125,-2.15625 z m 2.78125,-1.671875 c -0.457031,0.042969 -0.820313,0.140625 -1.09375,0.296875 -0.507813,0.28125 -0.765625,0.761719 -0.765625,1.4375 0,0.492187 0.179688,0.902344 0.53125,1.234375 0.34375,0.324219 0.789062,0.496094 1.328125,0.515625 z m -2.78125,1.78125 z" 
           id="path4899" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-9" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -8.03125,-0.984375 0,-1.0625 1.75,0 0,-1 0.859375,0 0,1 4.109375,0 c 0.21875,0 0.367188,-0.078125 0.4375,-0.234375 0.042969,-0.070312 0.0625,-0.207031 0.0625,-0.40625 0,-0.050781 0,-0.101562 0,-0.15625 -0.007812,-0.0625 -0.015625,-0.128906 -0.015625,-0.203125 l 0.828125,0 c 0.03125,0.117187 0.0507812,0.242187 0.0625,0.375 0.0195312,0.125 0.03125,0.265625 0.03125,0.421875 0,0.492188 -0.125,0.824219 -0.375,1 -0.25,0.179688 -0.578125,0.265625 -0.984375,0.265625 l -4.15625,0 0,0.84375 -0.859375,0 0,-0.84375 z" 
           id="path4902" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-10" 
         style="overflow:visible">         <path 
           style="stroke:none"            d="" 
           id="path4905" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-11" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -6.28125,-0.78125 0,-1 0.890625,0 c -0.363281,-0.289062 -0.625,-0.601562 -0.78125,-0.9375 -0.164063,-0.332031 -0.25,-0.703125 -0.25,-1.109375 0,-0.882813 0.3125,-1.484375 0.9375,-1.796875 0.34375,-0.175781 0.828125,-0.265625 1.453125,-0.265625 l 4.03125,0 0,1.078125 -3.953125,0 c -0.382813,0 -0.691406,0.058594 -0.921875,0.171875 -0.394531,0.1875 -0.59375,0.527344 -0.59375,1.015625 0,0.25 0.027344,0.453125 0.078125,0.609375 0.085937,0.292969 0.257813,0.546875 0.515625,0.765625 0.210938,0.179688 0.421875,0.292969 0.640625,0.34375 0.21875,0.054688 0.539063,0.078125 0.953125,0.078125 l 3.28125,0 0,1.046875 z M -6.421875,-3.25 Z" 
           id="path4908" 
           inkscape:connector-curvature="0" />       </symbol> 
      <symbol          overflow="visible"          id="glyph1-12" 
         style="overflow:visible">         <path 
           style="stroke:none" 
           d="m -4.078125,-8.1875 c 0,-0.5625 0.199219,-1.039062 0.59375,-1.4375 0.398437,-0.394531 0.875,-0.59375 1.4375,-0.59375 0.5625,0 1.046875,0.199219 1.453125,0.59375 C -0.195312,-9.226562 0,-8.75 0,-8.1875 c 0,0.574219 -0.195312,1.058594 -0.59375,1.453125 -0.40625,0.398437 -0.890625,0.59375 -1.453125,0.59375 -0.5625,0 -1.039063,-0.195313 -1.4375,-0.59375 -0.394531,-0.394531 -0.59375,-0.878906 -0.59375,-1.453125 z m -4.28125,0.859375 0,-0.65625 8.578125,4.703125 0,0.640625 z m 3.46875,4.90625 c 0,-0.34375 -0.113281,-0.628906 -0.34375,-0.859375 -0.238281,-0.238281 -0.523437,-0.359375 -0.859375,-0.359375 -0.332031,0 -0.613281,0.121094 -0.84375,0.359375 -0.238281,0.230469 -0.359375,0.515625 -0.359375,0.859375 0,0.335937 0.121094,0.621094 0.359375,0.859375 0.230469,0.230469 0.511719,0.34375 0.84375,0.34375 0.335938,0 0.621094,-0.113281 0.859375,-0.34375 0.230469,-0.238281 0.34375,-0.523438 0.34375,-0.859375 z m -3.25,0 c 0,-0.570313 0.203125,-1.054687 0.609375,-1.453125 0.398438,-0.394531 0.875,-0.59375 1.4375,-0.59375 0.5625,0 1.042969,0.199219 1.4375,0.59375 0.398438,0.398438 0.59375,0.882812 0.59375,1.453125 0,0.5625 -0.195312,1.042969 -0.59375,1.4375 -0.394531,0.398437 -0.875,0.59375 -1.4375,0.59375 -0.5625,0 -1.039062,-0.195313 -1.4375,-0.59375 -0.40625,-0.394531 -0.609375,-0.875 -0.609375,-1.4375 z m 7.3125,-5.765625 c 0,-0.320312 -0.117187,-0.601562 -0.359375,-0.84375 -0.238281,-0.238281 -0.523438,-0.359375 -0.859375,-0.359375 -0.320313,0 -0.601563,0.121094 -0.84375,0.359375 C -3.128906,-8.789062 -3.25,-8.507812 -3.25,-8.1875 c 0,0.34375 0.121094,0.636719 0.359375,0.875 0.242187,0.230469 0.523437,0.34375 0.84375,0.34375 0.335937,0 0.621094,-0.113281 0.859375,-0.34375 0.242188,-0.238281 0.359375,-0.53125 0.359375,-0.875 z" 
           id="path4911" 
           inkscape:connector-curvature="0" />       </symbol> 
    </g>     <clipPath        id="clip1">       <path 
         d="m 73,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4914"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip2">       <path 
         d="m 105,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4917"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip3">       <path 
         d="m 137,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4920"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip4">       <path 
         d="m 170,1.441406 1,0 0,228.519534 -1,0 z" 
         id="path4923"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip5">       <path 
         d="m 202,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4926"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip6">       <path 
         d="m 234,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4929"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip7">       <path 
         d="m 266,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4932"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip8">       <path 
         d="m 299,1.441406 1,0 0,228.519534 -1,0 z" 
         id="path4935"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip9">       <path 
         d="m 331,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4938"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip10">       <path 
         d="m 363,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4941"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip11">       <path 
         d="m 395,1.441406 2,0 0,228.519534 -2,0 z" 
         id="path4944"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip12">       <path 
         d="m 428,1.441406 1,0 0,228.519534 -1,0 z" 
         id="path4947"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip13">       <path 
         d="M 59.039062,220 460,220 l 0,1 -400.960938,0 z" 
         id="path4950"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip14">       <path 
         d="M 59.039062,167 460,167 l 0,2 -400.960938,0 z" 
         id="path4953"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip15">       <path 
         d="M 59.039062,114 460,114 l 0,2 -400.960938,0 z" 
         id="path4956"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip16">       <path 
         d="M 59.039062,62 460,62 l 0,1 -400.960938,0 z" 
         id="path4959"          inkscape:connector-curvature="0" /> 
    </clipPath>     <clipPath        id="clip17">       <path 
         d="M 59.039062,9 460,9 l 0,2 -400.960938,0 z" 
         id="path4962"          inkscape:connector-curvature="0" /> 
    </clipPath>   </defs>   <g      id="surface1">     <rect 
       x="0"        y="0"        width="504"        height="288" 
       style="fill:#ffffff;fill-opacity:1;stroke:none" 
       id="rect4965" />     <g        clip-path="url(#clip1)" 
       id="g4967"        style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 73.867188,228.96094 0,-227.519534" 
         id="path4969"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip2)"        id="g4971" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 106.09766,228.96094 0,-227.519534" 
         id="path4973"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip3)"        id="g4975" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 138.33203,228.96094 0,-227.519534" 
         id="path4977"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip4)"        id="g4979" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 170.5625,228.96094 0,-227.519534" 
         id="path4981"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip5)"        id="g4983" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 202.79297,228.96094 0,-227.519534" 
         id="path4985"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip6)"        id="g4987" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 235.02734,228.96094 0,-227.519534" 
         id="path4989"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip7)"        id="g4991" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 267.25781,228.96094 0,-227.519534" 
         id="path4993"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip8)"        id="g4995" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 299.48828,228.96094 0,-227.519534" 
         id="path4997"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip9)"        id="g4999" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 331.72266,228.96094 0,-227.519534" 
         id="path5001"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip10)"        id="g5003" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 363.95312,228.96094 0,-227.519534" 
         id="path5005"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip11)"        id="g5007" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 396.18359,228.96094 0,-227.519534" 
         id="path5009"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip12)"        id="g5011" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 428.41797,228.96094 0,-227.519534" 
         id="path5013"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip13)"        id="g5015" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 59.039062,220.53516 400.320308,0" 
         id="path5017"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip14)"        id="g5019" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 59.039062,167.86719 400.320308,0" 
         id="path5021"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip15)"        id="g5023" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 59.039062,115.19922 400.320308,0" 
         id="path5025"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip16)"        id="g5027" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 59.039062,62.535156 400.320308,0" 
         id="path5029"          inkscape:connector-curvature="0" /> 
    </g>     <g        clip-path="url(#clip17)"        id="g5031" 
       style="clip-rule:nonzero">       <path 
         style="fill:none;stroke:#d1d1d1;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-dasharray:0.75, 2.25;stroke-opacity:1" 
         d="m 59.039062,9.867188 400.320308,0"          id="path5033" 
         inkscape:connector-curvature="0" />     </g>     <path 
       style="fill:none;stroke:#dce317;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 73.867188,62.375 16.117187,-3.105469 16.113285,1.261719 16.11718,0.894531 16.11719,-0.839843 L 154.44531,51 170.5625,39.835938 l 16.11719,8.847656 16.11328,6.421875 16.11719,1.265625 16.11718,12.902344 16.11328,1.371093 16.11719,0 16.11719,2.105469 16.11328,-5.476562 16.11719,-1.371094 16.11719,-2.472656 16.11328,-7.953126 16.11718,-2.84375 16.11719,6.636719 16.11328,-6.636719 16.11719,8.109376 16.11719,7.164062 16.11719,2.367188" 
       id="maximumLine"        inkscape:connector-curvature="0" /> 
    <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 73.867188,228.96094 354.550782,0"        id="path5037" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 73.867188,228.96094 0,7.19922"        id="path5039" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 106.09766,228.96094 0,7.19922"        id="path5041" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 138.33203,228.96094 0,7.19922"        id="path5043" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 170.5625,228.96094 0,7.19922"        id="path5045" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 202.79297,228.96094 0,7.19922"        id="path5047" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 235.02734,228.96094 0,7.19922"        id="path5049" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 267.25781,228.96094 0,7.19922"        id="path5051" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 299.48828,228.96094 0,7.19922"        id="path5053" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 331.72266,228.96094 0,7.19922"        id="path5055" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 363.95312,228.96094 0,7.19922"        id="path5057" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 396.18359,228.96094 0,7.19922"        id="path5059" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 428.41797,228.96094 0,7.19922"        id="path5061" 
       inkscape:connector-curvature="0" />     <g 
       style="fill:#000000;fill-opacity:1"        id="g5063"> 
      <use          xlink:href="#glyph0-1"          x="70.53125" 
         y="254.87891"          id="use5065"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5067"> 
      <use          xlink:href="#glyph0-2"          x="102.76172" 
         y="254.87891"          id="use5069"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5071"> 
      <use          xlink:href="#glyph0-3"          x="134.99609" 
         y="254.87891"          id="use5073"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5075"> 
      <use          xlink:href="#glyph0-4"          x="167.22656" 
         y="254.87891"          id="use5077"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5079"> 
      <use          xlink:href="#glyph0-5"          x="199.45703" 
         y="254.87891"          id="use5081"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5083"> 
      <use          xlink:href="#glyph0-6"          x="228.35547" 
         y="254.87891"          id="use5085"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-1" 
         x="235.0293"          y="254.87891"          id="use5087" 
         width="100%"          height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5089"> 
      <use          xlink:href="#glyph0-6"          x="260.58594" 
         y="254.87891"          id="use5091"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-2" 
         x="267.25977"          y="254.87891"          id="use5093" 
         width="100%"          height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5095"> 
      <use          xlink:href="#glyph0-6"          x="292.81641" 
         y="254.87891"          id="use5097"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-3" 
         x="299.49023"          y="254.87891"          id="use5099" 
         width="100%"          height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5101"> 
      <use          xlink:href="#glyph0-6"          x="325.05078" 
         y="254.87891"          id="use5103"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-4" 
         x="331.72461"          y="254.87891"          id="use5105" 
         width="100%"          height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5107"> 
      <use          xlink:href="#glyph0-6"          x="357.28125" 
         y="254.87891"          id="use5109"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-5" 
         x="363.95508"          y="254.87891"          id="use5111" 
         width="100%"          height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5113"> 
      <use          xlink:href="#glyph0-2"          x="389.51172" 
         y="254.87891"          id="use5115"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-1" 
         x="396.18555"          y="254.87891"          id="use5117" 
         width="100%"          height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5119"> 
      <use          xlink:href="#glyph0-2"          x="421.74609" 
         y="254.87891"          id="use5121"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-2" 
         x="428.41992"          y="254.87891"          id="use5123" 
         width="100%"          height="100%" />     </g>     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,220.53516 0,-210.667972"        id="path5125" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,220.53516 -7.199218,0"        id="path5127" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,167.86719 -7.199218,0"        id="path5129" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,115.19922 -7.199218,0"        id="path5131" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,62.535156 -7.199218,0"        id="path5133" 
       inkscape:connector-curvature="0" />     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,9.867188 -7.199218,0"        id="path5135" 
       inkscape:connector-curvature="0" />     <g 
       style="fill:#000000;fill-opacity:1"        id="g5137"> 
      <use          xlink:href="#glyph0-1"          x="27.960938" 
         y="224.83984"          id="use5139"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-7" 
         x="34.634766"          y="224.83984"          id="use5141" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-1"          x="37.96875" 
         y="224.83984"          id="use5143"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5145"> 
      <use          xlink:href="#glyph0-1"          x="27.960938" 
         y="172.17188"          id="use5147"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-7" 
         x="34.634766"          y="172.17188"          id="use5149" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-8"          x="37.96875" 
         y="172.17188"          id="use5151"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5153"> 
      <use          xlink:href="#glyph0-6"          x="27.960938" 
         y="119.50391"          id="use5155"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-7" 
         x="34.634766"          y="119.50391"          id="use5157" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-1"          x="37.96875" 
         y="119.50391"          id="use5159"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5161"> 
      <use          xlink:href="#glyph0-6"          x="27.960938" 
         y="66.839844"          id="use5163"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-7" 
         x="34.634766"          y="66.839844"          id="use5165" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-8"          x="37.96875" 
         y="66.839844"          id="use5167"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5169"> 
      <use          xlink:href="#glyph0-2"          x="27.960938" 
         y="14.171875"          id="use5171"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-7" 
         x="34.634766"          y="14.171875"          id="use5173" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-1"          x="37.96875" 
         y="14.171875"          id="use5175"          width="100%" 
         height="100%" />     </g>     <path 
       style="fill:none;stroke:#000000;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 59.039062,228.96094 400.320308,0 0,-227.519534 -400.320308,0 0,227.519534" 
       id="path5177"        inkscape:connector-curvature="0" /> 
    <g        style="fill:#000000;fill-opacity:1"        id="g5179" 
       transform="translate(2)">       <use 
         xlink:href="#glyph0-9"          x="240.19531" 
         y="283.67969"          id="use5181"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-10" 
         x="248.86133"          y="283.67969"          id="use5183" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-11"          x="255.53516" 
         y="283.67969"          id="use5185"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-12" 
         x="259.53125"          y="283.67969"          id="use5187" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-13"          x="265.53125" 
         y="283.67969"          id="use5189"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph0-14" 
         x="272.20508"          y="283.67969"          id="use5191" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph0-15"          x="274.87109" 
         y="283.67969"          id="use5193"          width="100%" 
         height="100%" />     </g>     <g 
       style="fill:#000000;fill-opacity:1"        id="g5195"> 
      <use          xlink:href="#glyph1-1"          x="12.960938" 
         y="155.21875"          id="use5197"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-2" 
         x="12.960938"          y="146.55273"          id="use5199" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-3"          x="12.960938" 
         y="139.87891"          id="use5201"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-4" 
         x="12.960938"          y="133.20508"          id="use5203" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-5"          x="12.960938" 
         y="129.87109"          id="use5205"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-6" 
         x="12.960938"          y="127.20508"          id="use5207" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-7"          x="12.960938" 
         y="120.53125"          id="use5209"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-8" 
         x="12.960938"          y="114.53125"          id="use5211" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-5"          x="12.960938" 
         y="107.85742"          id="use5213"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-9" 
         x="12.960938"          y="105.19141"          id="use5215" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-10"          x="12.960938" 
         y="101.85742"          id="use5217"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-5" 
         x="12.960938"          y="98.523438"          id="use5219" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-11"          x="12.960938" 
         y="95.857422"          id="use5221"          width="100%" 
         height="100%" />       <use          xlink:href="#glyph1-10" 
         x="12.960938"          y="89.183594"          id="use5223" 
         width="100%"          height="100%" />       <use 
         xlink:href="#glyph1-12"          x="12.960938" 
         y="85.849609"          id="use5225"          width="100%" 
         height="100%" />     </g>     <path 
       style="fill:none;stroke:#2e6b8c;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 73.867188,109.72266 16.117187,6.26562 16.113285,3.95313 16.11718,11.26953 16.11719,20.22265 16.11328,5.74219 16.11719,6.21484 16.11719,5.58204 16.11328,6.47656 16.11719,2.89844 16.11718,4.84375 16.11328,7.16406 16.11719,1.94922 16.11719,0.78906 16.11328,-1.73828 16.11719,-0.0508 16.11719,-3.42578 16.11328,-12.95313 16.11718,-13.27344 16.11719,-8.95312 16.11328,-20.48828 16.11719,-6.26563 16.11719,-5.26953 16.11719,-5.73828" 
       id="KlarLine"        inkscape:connector-curvature="0" /> 
    <path 
       style="fill:none;stroke:#1e998a;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 73.867188,164.33984 16.117187,-1.84375 16.113285,-2.05468 16.11718,-0.73829 16.11719,-9.53125 16.11328,-7.84765 16.11719,-2.3711 16.11719,-4.63281 16.11328,-7.11328 16.11719,0.6875 16.11718,-6.10937 16.11328,-4.53125 16.11719,1.16015 16.11719,0.57813 16.11328,0.16015 16.11719,1.10547 16.11719,9.16406 16.11328,4.84375 16.11718,8.84766 16.11719,5.00391 16.11328,7.6914 16.11719,2.84375 16.11719,3.10547 16.11719,-2.52734" 
       id="starkLine"        inkscape:connector-curvature="0" /> 
    <path 
       style="fill:none;stroke:#45075c;stroke-width:0.75;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10;stroke-opacity:1" 
       d="m 73.867188,210.68359 16.117187,-0.57812 16.113285,1.26562 16.11718,-1.32031 16.11719,-1.26172 16.11328,-1.79297 16.11719,-1.15625 16.11719,-0.78906 16.11328,-0.6875 16.11719,-4.63281 16.11718,-2.63281 16.11328,-0.73829 16.11719,-1.52734 16.11719,-0.94922 16.11328,1.26563 16.11719,-2.16016 16.11719,5.58203 16.11328,1.47656 16.11718,1.89454 16.11719,1.6875 16.11328,4.47656 16.11719,-1.21094 16.11719,2.94922 L 444.53516,211" 
       id="MittelLine"        inkscape:connector-curvature="0" /> 
    <g        style="fill:#000000;fill-opacity:1"        id="g5179-1" 
       transform="translate(-117.37024,-335.94004)">       <text 
         xml:space="preserve" 
         style="font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:10.66666667px;line-height:125%;font-family:FontAwesome;-inkscape-font-specification:FontAwesome;text-align:start;letter-spacing:0px;word-spacing:0px;text-anchor:start;fill:#bfc517;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;" 
         x="309.68204"          y="381.88461"          id="text22688" 
         sodipodi:linespacing="125%"><tspan 
           sodipodi:role="line"            id="tspan22690" 
           x="309.68204"            y="381.88461" 
           style="font-size:10.66666667px;fill:#bfc517;fill-opacity:1;">Bedeckungsgrad 8</tspan></text> 
      <text          sodipodi:linespacing="125%" 
         id="text22696"          y="446.20703"          x="404.38226" 
         style="font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:10.66666698px;line-height:125%;font-family:FontAwesome;-inkscape-font-specification:FontAwesome;text-align:center;letter-spacing:0px;word-spacing:0px;text-anchor:middle;fill:#5eb6ab;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" 
         xml:space="preserve"><tspan 
           style="font-size:10.66666698px;text-align:center;text-anchor:middle;fill:#5eb6ab;fill-opacity:1" 
           y="446.20703"            x="404.38226" 
           id="tspan22698" 
           sodipodi:role="line">Bedeckungsgrad 7</tspan></text> 
      <text          sodipodi:linespacing="125%" 
         id="text22700"          y="442.82166"          x="196.27145" 
         style="font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:10.66666667px;line-height:125%;font-family:FontAwesome;-inkscape-font-specification:FontAwesome;text-align:start;letter-spacing:0px;word-spacing:0px;text-anchor:start;fill:#326e8e;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1;" 
         xml:space="preserve"><tspan 
           style="font-size:10.66666667px;fill:#326e8e;fill-opacity:1;" 
           y="442.82166"            x="196.27145" 
           id="tspan22702" 
           sodipodi:role="line">Bedeckungsgrad 0</tspan></text> 
      <text          xml:space="preserve" 
         style="font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;font-size:10.66666698px;line-height:125%;font-family:FontAwesome;-inkscape-font-specification:FontAwesome;text-align:start;letter-spacing:0px;word-spacing:0px;text-anchor:start;fill:#7f558f;fill-opacity:1;stroke:none;stroke-width:1px;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1" 
         x="310.53342"          y="552.84686"          id="text22704" 
         sodipodi:linespacing="125%"><tspan 
           sodipodi:role="line"            id="tspan22706" 
           x="310.53342"            y="552.84686" 
           style="font-size:10.66666698px;fill:#7f558f;fill-opacity:1">Bedeckungsgrad 4</tspan></text> 
    </g>   </g> </svg>
    </div>
  </div>  
</div>

<p style="clear: both;"></p> <!-- Platzhaltertext -->


<script  type="text/javascript">
function highlight(id){
  var i;
  var lines = ["maximumLine", "KlarLine", "MittelLine", "starkLine"];
  for(i = 0; i < lines.length; i++){
      document.getElementById(lines[i]).style.strokeWidth = "0.75px";
  }
  if (id != "none"){
    document.getElementById(id).style.strokeWidth = "3px";
  }
  
  return false;
}
</script>









# Was ändert sich über den Jahresverlauf?






<div id="Monatswerte">
  <ul class="nav nav-pills">
  </ul>
  
  <div id="BedTab" class="tab-content">
  </div>
</div>


<script type="text/javascript">
var Monate = ["Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember"]
var MonatsNav = d3.select("#Monatswerte").select("ul").selectAll("li");
MonatsNav.data(Monate).enter().append("li").classed('active', function(d,i) { return i == 0; }).append("a").attr("data-toggle", "tab").attr("href", function(d) { return "#"+ d;}
).attr("aria-expanded", "true").text(function(d) { return d; });

var MonatsTabContent = d3.select("#BedTab").selectAll("div").data(Monate).enter().append("div").attr("id", function(d) {return d;}).attr("class", "tab-pane").classed('active', function(d,i) { return i == 0; });

MonatsTabContent.append("img").attr("src", function(d, i) {return "/images/Monatliche_Bedeckung/Monatliche_Bedeckung_" + (i+1)  + ".svg";});

MonatsTabContent.append("img").attr("src", function(d, i) {return "/images/Monatliche_Bedeckung/Sonnenverlauf" + (i+1)  + ".png";});


</script>


<!-- # Regnet es nachts auch mehr? -->

















<script>
(function ($) {
  $(function () {
    $(document).off('click.bs.tab.data-api', '[data-hover="tab"]');
    $(document).on('mouseenter.bs.tab.data-api', '[data-toggle="tab"], [data-hover="tab"]', function () {
      $(this).tab('show');
    });
  });
})(jQuery);
</script>
