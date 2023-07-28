% Inicializar parâmetros de frequencia
fsIn = 50000;
fsOut = 2000;
fMin = 50;
fMax = 3000;
fFactorCoarse = 0.002;
fFactorFine = 0.00005;
f = fMin;

% Inicializar parâmetros de fase
phiMin = 0;
phiMax = 360;
phiStep = 1;
phi = phiMin;

% Inicializar parâmetros de tempo
tSound = 1;
tWidth = 1/fMin;
tLongIn = linspace(0, tSound, fsIn*tSound+1);
tIn = tLongIn(1:fsIn*tWidth+1);
tLongOut = linspace(0, tSound, fsOut*tSound+1);
tOut = tLongOut(1:fsOut*tWidth+1);

% Criar figura e controladores de eventos
figure('Name','Interactive Demo of Nyquist''s Sampling Theorem', ...
    'KeyPressFcn',@(~, event) setappdata(0, 'c', event.Key), ...
    'KeyReleaseFcn',@(~, ~) setappdata(0, 'c', 0), ...
    'ResizeFcn',@(~, ~) setappdata(0, 's', get(gcf, 'Position')));

% Loop infinito
while 1
    % Calcular os sinais de entrada e saída
    sLongIn = sin(2*pi*f*tLongIn + phi*pi/180);
    sIn = sLongIn(1:fsIn*tWidth+1);
    sLongOut = sin(2*pi*f*tLongOut + phi*pi/180);
    sOut = sLongOut(1:fsOut*tWidth+1);

    % Plotar sinais de entrada e saída e marcadores de amostras
    plot(1000*tIn, sIn, 'r', 'LineWidth', 3);
    hold on
    plot([0 1000*tWidth], [0 0], 'k');
    plot(1000*tOut, sOut, 'b', 'LineWidth', 3);
    plot(1000*tOut, sOut, 'ko', 'LineWidth', 3, 'MarkerSize', 10);
    hold off

    % "Ajuste a estética da figura"
    s = getappdata(0, 's');
    axis([0 1000*tWidth -1.1 1.1])
    title(['{\itf} = ' num2str(f, '%.1f') ' Hz     \phi = ' ...
        num2str(phi) '^\circ     {\itf_s} = ' num2str(fsOut) ...
        ' Hz     {\itf_s} / 2 = ' num2str(fsOut/2) ' Hz'])
    xlabel('Tempo (ms)')
    ylabel('Valor de sinal')
    set(gca, 'FontSize', s(3)/50)
    drawnow

    % Ajuste de parâmetros de simulação através de entrada do teclado.
    c = getappdata(0, 'c');
    if c == 'q', f = min(f*(1+fFactorCoarse), fMax); end
    if c == 'a', f = max(f*(1-fFactorCoarse), fMin); end
    if c == 'w', f = min(f*(1+fFactorFine), fMax); end
    if c == 's', f = max(f*(1-fFactorFine), fMin); end
    if c == 'e', phi = min(phi+phiStep, phiMax); end
    if c == 'd', phi = max(phi-phiStep, phiMin); end
    if c == 'r', f = fMin; phi = phiMin; end
    if c == 'i', try sound(sLongIn, fsIn), catch, end, end
    if c == 'o', try sound(sLongOut, fsOut), catch, end, end
    if strcmp(c, 'escape'), break; end
end
