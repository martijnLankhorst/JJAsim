function out = JJAsim_2D_visualize_snapshot(array,n,I,varargin)
%out = JJAsim_2D_snapshot(array,n,I,varargin)
%
%DESCRIPTION
% - Displays a snapshot of a 2D josephson junction array with a current configuration I 
%   and a vortex configuration n. 
% - Currents are displayed with arrows where the current is proportional to the strength.
% - Vortices are displayed as circles.
% - Currents and vortices can be displayed with a 'normal' or 'fancy' draw mode. Normal 
%   is more efficient. Set with arrowType and vortexType.
% - Optionally one can display island quantities with colored islands. Can for example be
%   used to display island phases or island potential. 
% - Optionally one can display path quantities with colored path area. Can for example be
%   used to display path currents or self fields.
% - Optionally one can display the islands in which external current is injected and ejected
%   with showIExtBaseQ. Injected islands get a dot and ejection islands get a cross.
%
%FIXED INPUT
% array               struct      information about Josephson junction array.
% n                   Np by 1     vortex configuration
% I                   Nj by 1     current configuration
%
%VARIABLE INPUT
% figurePosition      empty       automatic figure position
%                     1 by 1      figure is centered, between 0 and 1 where 1 = fullscreen.  
%                     1 by 4      manual figure position.       
% FontName            string      font name
% FontSize            1 by 1      font size
% showVorticesQ       1 by 1      If true, vortices are displayed in the centre of paths.
% vortexDiameter      1 by 1      Diameter of displayed vortices.
% vortexColor         1 by 3      RGB triplet for vortex color
% antiVortexColor     1 by 3      RGB triplet for antivortex color  
% vortexType          string      'normal' or 'fancy'. Draw mode for vortices.
% showGridQ           1 by 1      draw a line grid over all junctions
% gridWidth           1 by 1      width of gridlines
% gridColor           1 by 3      RGB triplet for grid color
% showCurrentQ        1 by 1      If true, current is displayed with arrows whose length
%                                 is proportional to the magnitude of the current.
% arrowWidth          1 by 1      width scale factor of current arrays.
% arrowLength         1 by 1      length scale factor of current arrays.
% arrowColor          1 by 3      RGB triplet for arrow color  
% arrowType           string      'normal' or 'fancy'. Draw mode for current arrows.
% showIslandsQ        1 by 1      If true, islands are shown as circles.
% islandDiameter      1 by 1      Diameter of displayed islands.
% islandColor         1 by 3      RGB triplet for color of islands 
%                                 (ignored if showIslandQuantityQ)
% showIslandQuantityQ 1 by 1      if true, islandQuantity is displayed with colored islands.
% islandQuantity      Nis by 1    quantity displayed with colored islands.   
% islandColorLimits   empty       automatic color limits for islandQuantity
%                     1 by 2      manual color limits for islandQuantity
% islandQuantityLabel string      Colorbar label for islandQuantity  
% showPathQuantityQ   1 by 1      if true, pathQuantity is displayed by coloring the 
%                                 enclosed area of each path.
% pathQuantity        Np by 1     quantity displayed with colored path areas.   
% pathColorLimits     empty       automatic color limits for pathQuantity
%                     1 by 2      manual color limits for pathQuantity
% pathQuantityLabel   string      Colorbar label for pathQuantity    
% pathQuantityAlpha   1 by 1      Transparancy of colored path areas.  
% showIExtBaseQ       1 by 1      Dispay the islands where external current is in/ejected.  
% IExtBaseColor       1 by 3      RGB color triplet for symbols displaying external current.
% 
%OUTPUT
% out.figureHandle    handle      figure handle  
% out.axisHandle      handle      axis handle
% out.colorbarHandle  handle      colorbar handle (if one exists)


%check if array is 2D
if array.ndims ~= 2
    error('input must be 2D array')
end

inputParameters = {
    'figurePosition'            [] 
    'FontName'                  'Arial'
    'FontSize'                  13   
    'showVorticesQ'             true
    'vortexDiameter'            0.3
    'vortexColor'               [0,0,0]
    'antiVortexColor'           [1,0,0]
    'vortexType'                'fancy'
    'showGridQ'                 true
    'gridWidth'                 0.05
    'gridColor'                 [.8,.8,.8]
    'showCurrentQ'              true
    'arrowWidth'                1
    'arrowLength'               1
    'arrowColor'                [0,0,1]
    'arrowType'                 'fancy'
    'showIslandsQ'              true
    'islandDiameter'            0.3
    'islandColor'               [1,1,1]
    'showIslandQuantityQ'       false
    'islandQuantity'            []
    'islandColorLimits'         []
    'islandQuantityLabel'       ''
    'showPathQuantityQ'         false
    'pathQuantity'              []
    'pathColorLimits'           []
    'pathQuantityLabel'         ''
    'pathQuantityAlpha'         1
    'showIExtBaseQ'             true
    'IExtBaseColor'             [0,0,0]
};

options = JJAsim_method_parseOptions(inputParameters,varargin,'JJAsim_2D_snapshot');

figurePosition = options.figurePosition;
fontSize = options.FontSize;
fontName = options.FontName;
showVorticesQ = options.showVorticesQ;
vortexDiameter = options.vortexDiameter;
vortexColor = options.vortexColor;
antiVortexColor = options.antiVortexColor;
vortexType = options.vortexType;
showGridQ = options.showGridQ;
gridWidth = options.gridWidth;
gridColor = options.gridColor;
showCurrentQ = options.showCurrentQ;
arrowWidth = options.arrowWidth;
arrowLength = options.arrowLength;
arrowColor = options.arrowColor;
arrowType = options.arrowType;
showIslandsQ = options.showIslandsQ;
islandDiameter = options.islandDiameter;
islandColor = options.islandColor;
showIslandQuantityQ = options.showIslandQuantityQ;
islandQuantity = options.islandQuantity;
islandColorLimits = options.islandColorLimits;
islandQuantityLabel = options.islandQuantityLabel;
showPathQuantityQ = options.showPathQuantityQ;
pathQuantity = options.pathQuantity;
pathColorLimits = options.pathColorLimits;
pathQuantityLabel = options.pathQuantityLabel;
pathQuantityAlpha = options.pathQuantityAlpha;
showIExtBaseQ = options.showIExtBaseQ;
IExtBaseColor = options.IExtBaseColor;

if showIExtBaseQ && isfield(array,'IExtBase') == false
    error('Cannot display IExtBase because array does not contain the field IExtBase');
end
if showIslandQuantityQ && showPathQuantityQ
    error('cannot simultaneously display an island quantity and a path quantity'); 
end


%prepare input
islandPosition = reshape(array.islandPosition,[],2);
junctionPosition = reshape(array.junctionPosition,[],4);
pathCentroid = reshape(array.pathCentroid,[],2);
pathPosition = reshape(array.pathPosition,[],1);
if showIslandQuantityQ
    islandQuantity = reshape(islandQuantity,[],1);
end
if showPathQuantityQ
    pathQuantity = reshape(pathQuantity,[],1);
end
if showIExtBaseQ
    IExtBase = reshape(array.IExtBase,[],1);
else
    IExtBase = [];
end
n = reshape(n,[],1);
I = reshape(I,[],1);
n = JJAsim_method_checkInput(n,'double',array.Np,0,'n');
I = JJAsim_method_checkInput(I,'double',array.Nj,0,'I');
if showIslandQuantityQ
    islandQuantity = JJAsim_method_checkInput(islandQuantity,'double',...
        array.Nis,0,'islandQuantity');
    if ~isempty(islandColorLimits)
        islandColorLimits = JJAsim_method_checkInput(islandColorLimits,'double',...
            [1,2],[1,0],'islandColorLimits');
    end
end
if showPathQuantityQ
    pathQuantity = JJAsim_method_checkInput(pathQuantity,'double',...
        array.Np,0,'pathQuantity');
    if ~isempty(pathColorLimits)
        pathColorLimits = JJAsim_method_checkInput(pathColorLimits,'double',...
            [1,2],[1,0],'pathColorLimits');
    end
end

%produce snapshot
[fh,ah,cb] = JJAsim_priv_snap_2D(islandPosition,junctionPosition,pathCentroid,pathPosition,n,...
    I,figurePosition,fontSize,fontName,showVorticesQ,vortexDiameter,vortexColor,...
    antiVortexColor,vortexType,showGridQ,gridWidth,gridColor,showCurrentQ,arrowWidth,...
    arrowLength,arrowColor,arrowType,...
    showIslandsQ,islandDiameter,islandColor,showIslandQuantityQ,islandQuantity,...
    islandColorLimits,islandQuantityLabel,showPathQuantityQ,pathQuantity,...
    pathColorLimits,pathQuantityLabel,pathQuantityAlpha,showIExtBaseQ,IExtBase,...
    IExtBaseColor);

%assign output plot handles
out.figureHandle = fh;
out.axisHandle = ah;
if ~isempty(islandQuantity)
    out.colorbarHandle = cb;
end
end

