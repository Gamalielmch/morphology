clear
padi='C:\Users\Usuario\Documents\MATLAB\particulas';
[filenamed, pathd]= uigetfile({'*.*'},'Images of CLASS ','MultiSelect', 'on',padi);
if pathd==0
    error('No files, try again, run function again');
end

if iscell(filenamed)
    nclass=length(filenamed);
    images=cell(nclass,1);
    for i=1:nclass
        I=imread([pathd, filenamed{i}]);
        if size(I,3)>3
            I=I(:,:,1:3);
        end
        images{i}=im2bw(mat2gray(I));
        
    end
else
    I=imread([pathd, filenamed]);
    if size(I,3)>3
        I=I(:,:,1:3);
    end
    images{1}=im2bw(mat2gray(I));
    nclass=1;
end
optimo=0.999976100000000;
nc=128;   %%% número de armónicos
ncr=3;    %%% Número de armónicos para la reconstrucción
graf=1;   %%% visualización de la reconstrucción
% figure, hold on
for i=1:nclass
    
    
    [a,b,c,d,A0,C0,mn]=elifou(images{i},nc,1);
    real=zeros(mn,2);
    recon=real;
    
    for t = 1 : mn
        x = 0.0;
        y = 0.0;
        for ii = 1: nc
            x = x + (a(ii) * cos(2 * ii * pi * t / mn) + b(ii) * sin(2 * ii * pi * t / mn));
            y = y + (c(ii) * cos(2 * ii * pi * t / mn) + d(ii) * sin(2 * ii * pi * t / mn));
        end
        real(t,1) = A0 + x;
        real(t,2) = C0 + y;
    end
    
    
    for um=1:100
        for t = 1 : mn
            x = 0.0;
            y = 0.0;
            for ii = 1: um
                x = x + (a(ii) * cos(2 * ii * pi * t / mn) + b(ii) * sin(2 * ii * pi * t / mn));
                y = y + (c(ii) * cos(2 * ii * pi * t / mn) + d(ii) * sin(2 * ii * pi * t / mn));
            end
            recon(t,1) = A0 + x;
            recon(t,2) = C0 + y;
        end
        [NSx, ~] = nashsutcliffe([(1:t)', recon(:,1)], [(1:t)', real(:,1)]);
        [NSy, ~] = nashsutcliffe([(1:t)', recon(:,2)], [(1:t)', real(:,2)]);
%          [NSx, ~] = nashsutcliffe([(1:t)', log(recon(:,1)-min(recon(:,1))+1e-10)], [(1:t)', log(real(:,1)-min(real(:,1))+1e-10)]);
%         [NSy, ~] = nashsutcliffe([(1:t)', log(recon(:,2)-min(recon(:,2))+1e-10)], [(1:t)', log(real(:,2)-min(real(:,2))+1e-10)]);
        Ns(um,i)=(NSx+NSy)/2;
    end
    umbral2(i)=find(Ns(:,i)>=optimo,1);
    
    %  figure, plot(Ns(1:10)), hold on
    %   plot(Ns(1:20)), hold on
    [ind,ix]=knee_pt(1:8,Ns(1:8,i));
    %umbral(i)=3;
    umbral(i)=3;
    %plot(ix,ind,'o');
    for t = 1 : mn
        x = 0.0;
        y = 0.0;
        for ii = 1: umbral(i)
            x = x + (a(ii) * cos(2 * ii * pi * t / mn) + b(ii) * sin(2 * ii * pi * t / mn));
            y = y + (c(ii) * cos(2 * ii * pi * t / mn) + d(ii) * sin(2 * ii * pi * t / mn));
        end
        recon(t,1) = A0 + x;
        recon(t,2) = C0 + y;
    end
    umbral3(i)=ind;
    umbral(i)=sum(   sqrt(  (recon(:,1)- real(:,1)).^2 +  (recon(:,2)- real(:,2)).^2  )  ) /...
              sum(   sqrt(  (recon(:,1)).^2 +  (recon(:,2)).^2  )  );
%     figure
%     plot(recon(:,1), recon(:,2), 'r', 'linewidth', 1);
%     axis equal
%     hold on
%     plot(real(:,1), real(:,2), 'k', 'linewidth', 1);
%     title(num2str(umbral2(i)))
end
figure
plot([1:5],umbral3(1:5),'r+')
hold on
plot([6:10],umbral3(6:10),'g+')
plot([11:15],umbral3(11:15),'b+')
plot([16:20],umbral3(16:20),'k+')
plot([21:25],umbral3(21:25),'c+')

figure
plot(umbral(1:5),umbral2(1:5),'r+')
hold on
plot(umbral(6:10),umbral2(6:10),'g+')
plot(umbral(11:15),umbral2(11:15),'b+')
plot(umbral(16:20),umbral2(16:20),'k+')
plot(umbral(21:25),umbral2(21:25),'c+')

%
% for i=1:nclass
%
%
%     [a,b,c,d,A0,C0,mn]=elifou(images{i},nc,1);
%     real=zeros(mn,2);
%     recon=real;
%
%     for t = 1 : mn
%         x = 0.0;
%         y = 0.0;
%         for ii = 1: nc
%             x = x + (a(ii) * cos(2 * ii * pi * t / mn) + b(ii) * sin(2 * ii * pi * t / mn));
%             y = y + (c(ii) * cos(2 * ii * pi * t / mn) + d(ii) * sin(2 * ii * pi * t / mn));
%         end
%         real(t,1) = A0 + x;
%         real(t,2) = C0 + y;
%     end
%
%
%     for um=1:100
%         for t = 1 : mn
%             x = 0.0;
%             y = 0.0;
%             for ii = 1: um
%                 x = x + (a(ii) * cos(2 * ii * pi * t / mn) + b(ii) * sin(2 * ii * pi * t / mn));
%                 y = y + (c(ii) * cos(2 * ii * pi * t / mn) + d(ii) * sin(2 * ii * pi * t / mn));
%             end
%             recon(t,1) = A0 + x;
%             recon(t,2) = C0 + y;
%         end
%         [NSx, ~] = nashsutcliffe([(1:t)', recon(:,1)], [(1:t)', real(:,1)]);
%         [NSy, ~] = nashsutcliffe([(1:t)', recon(:,2)], [(1:t)', real(:,2)]);
%         Ns(um,i)=(NSx+NSy)/2;
%     end
%
%     %  figure, plot(Ns(1:10)), hold on
%     %   plot(Ns(1:20)), hold on
%     [ind,ix]=knee_pt(1:8,Ns(1:8));
%     umbral(i)=find(Ns(:,i)>=0.99996,1);
% end
% umbral=0;
% l=-10;
% optimo=0;
% val=0.9:0.000001:.999999;
% for opt=1:length(val)
%     i=1;
%     for part=1:nclass
%         try
%             umbral(part)=find(Ns(:,part)>=val(opt),1);
%         catch
%             umbral(part)=100;
%         end
%         i=i+1;
%     end
%     mini=min(umbral(1:10));
%     maxi=max(umbral(11:end));
%     if (mini-maxi)>l
%         l=(mini-maxi);
%         optimo=val(opt);
%     end
% end
%
% for part=1:nclass
%     umbral(part)=find(Ns(:,part)>=optimo,1);
% end
%
% figure
% plot([1:5],umbral(1:5),'r+')
% hold on
% plot([6:10],umbral(6:10),'g+')
% plot([11:15],umbral(11:15),'b+')
% plot([16:20],umbral(16:20),'k+')
% plot([21:25],umbral(21:25),'c+')
%
% optimo=0.999976100000000; %% superclase 1      mini=min(umbral(1:10));    maxi=max(umbral(11:end));
