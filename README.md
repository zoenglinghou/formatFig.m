# formatFig.m
`formatFig` formats figures according to scientific paper's standard. Output
`.eps` to a relative directory.

## Installation
In shell, clone the repository to a folder of your choice:
```bash
    git clone https://github.com/CarlosEvo/formatFig.m.git FOLDERNAME
```

In Matlab, add the folder to your path:
```matlab
    addpath(FOLDERNAME)
    savepath
```

## Usage
+ Use the function with:
```matlab
    formatFig(fig, fileName, varargin)
```
+ Required:
    - `fig`: the figure handle
    - `fileName`: file name of the .eps file
+ Options:
    - `orientation`: size/orientation of the output eps:
        - `image` (default): 3" x 2" eps. Use `imageSize` to specify sizes.
        - `landscape`: landscape letter size.
        - `portrait`: portrait letter size.
    - `imageSize`: size of image/eps: 1 x 2 positive double array in inches. (Default: [3, 2])
    - `axisLocation`: location of x & y axes:
        - `default` (default): default configuration.
        - `origin`: both axes passes through origin.
    - `XAxisLocation`: location of x axes:
        - `bottom` (default): default configuration.
        - `origin`: x axis passes through origin.
        - `top`: x axis at top of the figure.
    - `YaxisLocation`: locations of y axes:
        - `left` (default): default configuration.
        - `origin`: y axis passes through origin.
        - `right`: y axis to the right of the figure.
    - `axisScale`: change scale & ticks of axis:
       `linear`, `semilogx`, `semilogy`, `loglog`, `default` (default)
    - `XLabel`: set label of x axis, with LaTeX. (Default: '')
    - `YLabel`: set label of y axis, with LaTeX. (Default: '')
    - `YLabelLeft`: set label of left y axis, with LaTeX. (Default: '')
    - `YLabelRight`: set label of right y axis, with LaTeX. (Default: '')
    - `tickNum`: number of ticks on both axes. (Default: 5)
    - `legends`: set legends. (Default: {})
    - `fontSize`: size of font of the axes. (Default: 18)
    - `fontName`: font name of the labels. (Default: 'Times New Roman')
