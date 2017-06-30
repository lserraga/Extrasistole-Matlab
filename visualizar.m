%LUIS SERRA GARCÍA Y JUAN LUIS TORRALBO MUÑOZ
close all;
clear all;

%leemos el fichero de sonido
[aif,fs,NBITS,CHUNKDATA]=aiffread('Normal/153_1306848820671_B.aiff');
aif=double(aif);

% definimos el vector de tiempo
t=[1/fs:1/fs:length(aif)/fs]'; 

%Energía de la señal
energia=(aif).^2;
%Encontramos los picos de energia de la señal que serán los S1 y S2
[X,etiq]=findpeaks(energia,'minpeakheight',200000000,'minpeakdistance',200);
% leemos las etiquetas que marcan las 
label=[[(etiq'/fs)' aif(etiq')]];
    
%transformada de la señal entera
Transformada=fft(aif);
F=length(t);
mitadf=ceil(F/2); %Redondear la mitad de F
mediaonda=Transformada(1:mitadf);%Se representa la mitad de la transformada ya que si no sale duplicada la grafica
dF=1/t(end); %tiempo maximo
fss=0:dF:(mitadf-1)*dF;%definimos el vector frecuencia




%Representacion de la señal en el dominio del tiempo
subplot(4,1,1)
figure(1);
plot(t,aif);
xlabel('Tiempo(s)');
xlabel('Amplitud');
hold on;
plot(label(:,1), label(:,2),'*r');

%Representacion de la señal en el dominio de la frecuencia
subplot(4,1,2);
plot(fss,mediaonda);
xlabel('Frecuencia(Hz)');
ylabel('Magnitud FFT');

%Representamos la energia
subplot(4,1,3);
plot(t,energia);
xlabel('Tiempo');
ylabel('Energía');

%representamos el espectograma
subplot(4,1,4)
spectrogram(aif,128,120,128,fs,'yaxis');
xlabel('Tiempo(s)');
ylabel('Amplitud');

duracion=t(end);
%Amplitud temporal de las ventanas espectrales optima para que haya 1
%sonido en cada una que se consigue dividiendo la longitud de t por el
%numero de picos de energia
dt=duracion/length(etiq);
x=input('');
close all

%Bucle para realizar la trnaformada de Fourier en ventanas espectrales
%donde solo haya un ruido(S1 S2)
for i=0.25:dt:duracion
    t1=(t>=i-0.25)&(t<=i);
    subplot(3,1,1);
    plot(t,aif);
    hold on;
    plot(t(t1),aif(t1),'r');%Muestra por que parte de la señal va la ventana espectral
    xlabel('Tiempo(s)');
    subplot(3,1,2);
    plot(1000*t(t1),aif(t1))%Se multiplica por 1000 para verlo en ms
    xlabel('Tiempo(ms)');
    axis([1000*(i-0.25) 1000*(i) -40000 40000]);%Para que siempre salgan a la misma escala
    x=input('Introducir desplazamiento para el t si el ruido queda cortado o pulsar intro si es correcto');
    if (-10<x<10)%Condicion if por si parte del sonido s1 o s2 queda fuera de la señal
        i=i+x;
        t1=(t>=i-0.25)&(t<=i);
        subplot(3,1,2);
        plot(1000*t(t1),aif(t1))%Representa de nuevo la señal en el nuevo intervalo
        axis([1000*(i-0.25) 1000*(i) -40000 40000]);%Para que siempre salgan a la misma escala
    end
    F1=fft(aif(t1));
    subplot(3,1,3);
    mitadf1=ceil(length(t(t1))/2);%mitad del vector de tiempos
    f=(1:mitadf1);
    subplot(3,1,3);
    p=plot(f,F1(1:mitadf1));
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    x=input('');
    delete(p);    
end