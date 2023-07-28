fs_in = 50000;
fs_out = 2000;
f_min = 50;
f_max = 3000;
f_factor_coarse = 0.002;
f_factor_fine = 0.00005;
f = f_min;
% Inicializar parâmetros de fase
phi_min = 0;
phi_max = 360;
phi_step = 1;
phi = phi_min;
% Inicializar parâmetros de tempo
t_sound = 1;
t_width = 1/f_min;
t_long_in = linspace(0,t_sound,fs_in*t_sound+1);
t_in = t_long_in(1:fs_in*t_width+1);
t_long_out = linspace(0,t_sound,fs_out*t_sound+1);
t_out = t_long_out(1:fs_out*t_width+1);
% Criar figura e controladores de eventos
figure('Name','Interactive Demo of Nyquist''s Sampling Theorem', ...
    'KeyPressFcn',@(~,event) setappdata(0,'c',event.Key), ...
    'KeyReleaseFcn',@(~,~) setappdata(0,'c',0), ...
    'ResizeFcn',@(~,~) setappdata(0,'s',get(gcf,'Position')));
% Loop infinito
while 1
    % Calcular os sinais de entrada e saída
    s_long_in = sin(2*pi*f*t_long_in+phi*pi/180);
    s_in = s_long_in(1:fs_in*t_width+1);
    s_long_out = sin(2*pi*f*t_long_out+phi*pi/180);
    s_out = s_long_out(1:fs_out*t_width+1);
    % Plotar sinais de entrada e saída e marcadores de amostras
    plot(1000*t_in,s_in,'r','LineWidth',3);
    hold on
    plot([0 1000*t_width],[0 0],'k');
    plot(1000*t_out,s_out,'b','LineWidth',3);
    plot(1000*t_out,s_out,'ko','LineWidth',3,'MarkerSize',10);
    hold off
    % "Ajuste a estética da figura
    s = getappdata(0,'s');
    axis([0 1000*t_width -1.1 1.1])
    title(['{\itf} = ' num2str(f,'%.1f') ' Hz     \phi = ' ...
        num2str(phi) '^\circ     {\itf_s} = ' num2str(fs_out) ...
        ' Hz     {\itf_s} / 2 = ' num2str(fs_out/2) ' Hz'])
    xlabel('Tempo (ms)')
    ylabel('Valor de sinal')
    set(gca,'FontSize',s(3)/50)
    drawnow
    % Ajuste de parâmetros de simulação através de entrada do teclado.
    c = getappdata(0,'c');
    if c == 'q', f = min(f*(1+f_factor_coarse),f_max); end
    if c == 'a', f = max(f*(1-f_factor_coarse),f_min); end
    if c == 'w', f = min(f*(1+f_factor_fine),f_max); end
    if c == 's', f = max(f*(1-f_factor_fine),f_min); end
    if c == 'e', phi = min(phi+phi_step,phi_max); end
    if c == 'd', phi = max(phi-phi_step,phi_min); end
    if c == 'r', f = f_min; phi = phi_min; end
    if c == 'i', try sound(s_long_in,fs_in), catch, end, end
    if c == 'o', try sound(s_long_out,fs_out), catch, end, end
    if strcmp(c,'escape'), break; end
end