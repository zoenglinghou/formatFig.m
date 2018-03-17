function [] = formatFig( fig, fileName, varargin )
%FORMATFIG Format Figure and Save as EPS
% + Use the function with:
% ```matlab
%     formatFig(fig, fileName, varargin)
% ```
% + Required:
%     - `fig`: the figure handle
%     - `fileName`: file name of the .eps file
% + Options:
%     - `orientation`: size/orientation of the output eps:
%         - `image` (default): 3" x 2" eps. Use `imageSize` to specify sizes.
%         - `landscape`: landscape letter size.
%         - `portrait`: portrait letter size.
%     - `imageSize`: size of image/eps: 1 x 2 positive double array in inches. (Default: [3, 2])
%     - `axisLocation`: location of x & y axes:
%         - `default` (default): default configuration.
%         - `origin`: both axes passes through origin.
%     - `XAxisLocation`: location of x axes:
%         - `bottom` (default): default configuration.
%         - `origin`: x axis passes through origin.
%         - `top`: x axis at top of the figure.
%     - `YaxisLocation`: locations of y axes:
%         - `left` (default): default configuration.
%         - `origin`: y axis passes through origin.
%         - `right`: y axis to the right of the figure.
%     - `axisScale`: change scale & ticks of axis:
%        `linear`, `semilogx`, `semilogy`, `loglog`, `default` (default)
%     - `XLabel`: set label of x axis, with LaTeX. (Default: '')
%     - `YLabel`: set label of y axis, with LaTeX. (Default: '')
%     - `YLabelLeft`: set label of left y axis, with LaTeX. (Default: '')
%     - `YLabelRight`: set label of right y axis, with LaTeX. (Default: '')
%     - `tickNum`: number of ticks on both axes. (Default: 5)
%     - `legends`: set legends. (Default: {})
%     - `fontSize`: size of font of the axes. (Default: 18)
%     - `fontName`: font name of the labels. (Default: 'Times New Roman')


p = inputParser;
% Required
addRequired(p, 'fig', @(x) isa(x, 'matlab.ui.Figure'));
% addRequired(p, 'ax', @(x) isOrContain(x, 'matlab.graphics.axis.Axes'));
addRequired(p, 'fileName', @ischar);
% Parameters
addParameter(p, 'orientation', 'image', @(x)...
	~isempty(regexpi(x, {'Landscape', 'Portrait', 'Image'})));
addParameter(p, 'imageSize', [3, 2], @(x) all(size(x) == [1, 2]) && all(x > 0));
addParameter(p, 'axisLocation', 'default',...
	@(x) memberOrContain(x, {'default', 'origin'}));
addParameter(p, 'XAxisLocation', 'bottom',...
	@(x) memberOrContain(x, {'bottom', 'origin', 'top'}));
addParameter(p, 'YAxisLocation', 'left',...
	@(x) memberOrContain(x, {'left', 'origin', 'right'}));
addParameter(p, 'axisScale', 'default',...
	@(x) memberOrContain(x, {'linear', 'semilogx', 'semilogy', 'loglog', 'default'}));
addParameter(p, 'XLabel', '', @(x) isOrContain(x, 'char') || isOrContain(x, 'cell'));
addParameter(p, 'YLabel', '', @(x) isOrContain(x, 'char') || isOrContain(x, 'cell'));
addParameter(p, 'XLim', [],	@(x) isOrContain(x, 'double'));
addParameter(p, 'YLim', [], @(x) isOrContain(x, 'double'));
addParameter(p, 'YLabelLeft', '', @(x) isOrContain(x, 'char') || isOrContain(x, 'cell'));
addParameter(p, 'YLabelRight', '', @(x) isOrContain(x, 'char') || isOrContain(x, 'cell'));
addParameter(p, 'tickNum', 5, @isinteger);
addParameter(p, 'legends', {},  @(x) isOrContain(x, 'char') || isOrContain(x, 'cell'));
addParameter(p, 'fontSize', 18, @isfloat);
addParameter(p, 'fontName', 'Times New Roman', @ischar);

% Parse input
parse(p, fig, fileName, varargin{:});
fig = p.Results.fig;
% ax = p.Results.ax;
fileName = p.Results.fileName;
orientation = p.Results.orientation;
imageSize = p.Results.imageSize;
axisLocation = p.Results.axisLocation;
XAxisLocation = p.Results.XAxisLocation;
YAxisLocation = p.Results.YAxisLocation;
axisScale = p.Results.axisScale;
XLabel = p.Results.XLabel;
YLabel = p.Results.YLabel;
XLim = p.Results.XLim;
YLim = p.Results.YLim;
YLabelLeft = p.Results.YLabelLeft;
YLabelRight = p.Results.YLabelRight;
tickNum = p.Results.tickNum;
legends = p.Results.legends;
fontSize = p.Results.fontSize;
fontName = p.Results.fontName;

% Convert to cells
ax = findall(fig,'type','axes');
axisNum = numel(ax);
ax = arrayfun(@(ax) ax, ax, 'uni', 0);

axisProperties = {...
	'axisLocation', 'XAxisLocation', 'YAxisLocation',...
	'axisScale',...
	'XLabel', 'YLabel',...
	'YLabelLeft', 'YLabelRight'...
};
for itemIdx = 1: numel(axisProperties)
	item = axisProperties{itemIdx};
	itemValue = eval(item);
	if ~isa(itemValue, 'cell') % Single element
		evalc(['clear(''' item ''')']);
		evalc([item '(1: axisNum) = {''' itemValue '''}']);
	elseif isa(itemValue, 'cell') && numel(itemValue) == 1 % A cell containing only one element
		evalc(['clear(''' item ''')']);
		evalc([item '(1: axisNum) = ' itemValue]);
	elseif numel(itemValue) ~= axisNum
		error('%s should have the same number as axes.', item);
	end
end

% For XLim and YLim
XLim_tmp = XLim;
if ~isa(XLim, 'cell')
	clear('XLim');
	XLim(1: axisNum) = {XLim_tmp};
elseif isa(XLim, 'cell') && numel(XLim) == 1
	clear('XLim');
	XLim(1: axisNum) = XLim_tmp;
elseif numel(XLim) ~= axisNum
	error('XLim should have the same number as axes.');
end
YLim_tmp = YLim;
if ~isa(YLim, 'cell')
	clear('YLim');
	YLim(1: axisNum) = {YLim_tmp};
elseif isa(YLim, 'cell') && numel(YLim) == 1
	clear('YLim');
	YLim(1: axisNum) = YLim_tmp;
elseif numel(YLim) ~= axisNum
	error('YLim should have the same number as axes.');
end

% Prepare
set(fig,'PaperPositionMode', 'auto');

% Execution
% Axis Locations
if ~useDefault('XAxisLocation', p) || ~useDefault('YAxisLocation', p)
	cellfun(@(ax, XAxisLocation, YAxisLocation)...
		set(ax, 'XAxisLocation', XAxisLocation,	'YAxisLocation', YAxisLocation),...
		ax, XAxisLocation, YAxisLocation);
elseif ~useDefault('AxisLocation', p)
	cellfun(@(ax, axisLocation) set(ax, 'XAxisLocation', axisLocation,...
		'YAxisLocation', axisLocation), ax, axisLocation);
end

% Axis Labels
if ~useDefault('YLabelLeft', p) || ~useDefault('YLabelRight', p)
	cellfun(@(ax, YLabelLeft, YLabelRight)...
	setLnRYLabels(ax, YLabelLeft, YLabelRight), ax, YLabelLeft, YLabelRight)
elseif ~useDefault('YLabel', p)
	cellfun(...
        @(ax, YLabel) set(...
            ax.YLabel, 'String', YLabel, 'Interpreter', 'latex'...
        ),...
        ax, YLabel...
    );
end
cellfun(...
    @(ax, XLabel) set(ax.XLabel, 'String', XLabel, 'Interpreter', 'latex'),...
    ax, XLabel...
);

% Axis Limits
if ~useDefault('XLim', p)
	cellfun(@(ax, XLim) set(ax, 'XLim', XLim), ax, XLim);
	Lx = XLim;
else
	Lx = cellfun(@(ax) get(ax, 'XLim'), ax,...
		'UniformOutput', 0);
end
if ~useDefault('YLim', p)
	cellfun(@(ax, YLim) set(ax, 'YLim', YLim), ax, YLim);
	Ly = YLim;
else
	Ly = cellfun(@(ax) get(ax, 'YLim'), ax,...
		'UniformOutput', 0);
end

% Axis Scale
if ~useDefault('axisScale', p)
	[xScale, yScale, xTick, yTick] = cellfun(...
		@(axisScale, Lx, Ly) genScaleTick(axisScale, Lx, Ly, tickNum),...
		axisScale, Lx, Ly, 'uni', 0 ...
	);

    % Set scales
    cellfun(...
        @(ax, xScale, yScale) set(...
            ax,...
            'XScale', xScale, 'YScale', yScale...
        ),...
        ax, xScale, yScale...
    );

	% Set ticks
    for ax_idx = 1: length(ax)
        if ~isempty(xTick{ax_idx})
            set(ax{ax_idx}, 'XTick', cell2mat(xTick(ax_idx)));
        end
        if ~isempty(yTick{ax_idx})
            set(ax{ax_idx}, 'YTick', cell2mat(yTick(ax_idx)));
        end
    end
end

% Increase line width and marker size
lines = findall(fig, 'Type', 'line');
if ~isempty(lines)
    if any([lines.LineWidth] == 0.5)
        arrayfun(@(lines) set(lines, 'LineWidth', lines.LineWidth .* 2), lines);
    end
    if any([lines.MarkerSize] == 6)
        arrayfun(@(lines) set(lines, 'MarkerSize', lines.MarkerSize .* 1.5), lines);
    end
end

% Font type and size for axes
cellfun(@(ax) set(ax, 'FontSize', fontSize, 'FontName', fontName), ax);

% Font for all texts
text = findall(fig, 'Type', 'text');
arrayfun(@(text) set(text, 'FontSize', fontSize, 'FontName', fontName), text);

% Legend
if ~useDefault('legends', p)
    if isa(legends{1}, 'char') % Single legend
        for ax_idx = 1: axisNum
            axes(ax{ax_idx});
            legend(legends, 'Location', 'Best', 'Interpreter', 'Latex');
        end
    elseif isa(legends{1}, 'cell') && numel(legends) == axisNum
        for ax_idx = 1: axisNum
            axes(ax{ax_idx});
            legend(legends{ax_idx}, 'Location', 'Best', 'Interpreter', 'Latex');
        end
    else
        error('Legends should have the same number as axes.');
    end
end

% Paper Size
switch orientation
	case 'image'
		set(fig,...
            'PaperUnits', 'Inches',...
			'PaperSize', imageSize...
        );
	case {'Landscape', 'Portrait'}
		set(fig, 'PaperOrientation', orientation);
end

print(fig, fileName, '-depsc');


end

function [] = setLnRYLabels( ax, labelLeft, labelRight )
% setLnRYLabels: set the text of the ylabel left and right
%
% [] = setLnRYLabels( ax, labelLeft, labelRight )

	subplot(ax);
	yyaxis left;
    set(ax.YLabel, 'String', labelLeft, 'Interpreter', 'latex');
	yyaxis right;
	set(ax.YLabel, 'String', labelRight, 'Interpreter', 'latex');

end  % setLnRYLabels

function bool = useDefault(exp, p)

bool = ~isempty(find(arrayfun(@(x) strcmpi(exp, x), p.UsingDefaults), 1));

end

function bool = isOrContain(obj, class)
	if isa(obj, 'cell')
		bool = all(cellfun(@(x) isa(x, class), obj));
	else
		bool = isa(obj, class);
	end
end

function bool = memberOrContain( obj, group )
	if isa(obj, 'cell')
		bool = all(cellfun(@(x) ~isempty(regexpi(x, group)), obj));
	else
		bool = ~isempty(regexpi(obj, group));
	end
end

function [xScale, yScale, xTick, yTick] = genScaleTick (axisScale, Lx, Ly, tickNum)
	switch axisScale
		case 'semilogx'
			xScale = 'log';
			yScale = 'linear';
            xTick = [];
			yTick = linspace(Ly(1), Ly(2), tickNum);
		case 'semilogy'
			xScale = 'linear';
			yScale = 'log';
			xTick = linspace(Lx(1), Lx(2), tickNum);
            yTick = [];
		case 'loglog'
			xScale = 'log';
			yScale = 'log';
            xTick = [];
            yTick = [];
		case 'linear'
			xScale = 'linear';
			yScale = 'linear';
			xTick = linspace(Lx(1), Lx(2), tickNum);
			yTick = linspace(Ly(1), Ly(2), tickNum);
	end
end

function [logNum] = getLogNum(axLim, tickNum)

	axLog = [floor(log10(axLim(1))), ceil(log10(axLim(2)))];

	if range(axLog) + 1 == tickNum
		logNum = tickNum;
	elseif range(axLog) + 1 < tickNum
		logNum = range(axLog) + 1;
	else
		div = 1: tickNum - 1;
		logNum = max(div(~rem(axLog, div))) + 1;
	end

end
