function FEAT(wt,par,ratiomat,output)

%
%--------------------------------------------------------------------------------
% Multitrace Features Extraction
%--------------------------------------------------------------------------------
%
%
% Function Definition
%
% FEAT(wt,par,ratiomat,output)
%
% INPUT       TYPE         MEANING
% -----       ----         -------
% wt       -> matrix    -> 1st WT Output - Continuous Wavelet Transform
% par      -> structure -> 2nd WT Output - Parameters
% ratiomat -> matrix    -> [PDOutput1;PDOutput2;PDOutput3;...]
% output   -> boolean   -> Print .eps Output Graphs
%
% OUTPUT      TYPE         MEANING
% ------      ----         -------
% -none-   -> plot      -> 1 Plot Resulting from Analysis
%
% WARNING: This code represents a temporary implementation of FEAT function
% ======== because it does not allow comparison among traces acquired under
%          different recording parameters (sampling time, length,...).
%  

% Variables Assignment
timeVec = par.x;
freqVec = par.y;
periodVec = par.z;
lowest = freqVec(end)/(2**(length(freqVec)-1));
mark = par.m;

x = abs(wt);
y = abs(real(wt));

nscale = size(x)(1);
nvoice = (size(x)(1))/(length(freqVec)-1);
n = size(x)(2);

% Output Print control - Default value = false
if (nargin < 4)
	output = false;
endif

meanratio = mean(ratiomat);
stdevratio = std(ratiomat);
stderratio = stdevratio./sqrt(size(ratiomat)(1));

% Upper and Lower Confidence Interval bounds
% Under the hypothesis of log-normal data distribution
mu = log(meanratio./sqrt((stderratio.**2)./(meanratio.**2).+1));
sigma = sqrt(log((stderratio.**2)./(meanratio.**2).+1));

upci = e.**(mu.+1.96*sigma);
lowci = e.**(mu.-1.96*sigma);

% Under the hypothesis of normal data distribution
%upci = meanratio.+1.96*stderratio;
%lowci = meanratio.-1.96*stderratio;

figure

plot(meanratio,'-r','LineWidth',2), hold on
plot([min(xlim),max(xlim)],[1,1],'-g','LineWidth',2)
%plot(upci,'-b','LineWidth',1)
plot(lowci,'-b','LineWidth',1)

axis([0,nscale])
set(gca,'XTick',[0:nvoice:nscale]);
set(gca,'XTickLabel',freqVec);
xlabel('Frequency (mHz)','FontSize',18)
ylabel('post / pre Ratio','FontSize',18)
set(gca,'position',[0.130,0.110,0.775,0.68])

axes('XAxisLocation','top');
set(gca,'YTick',[]);
axis([0,nscale])
set(gca,'XTick',[0:nvoice:nscale]);
set(gca,'XTickLabel',periodVec);
xlabel('Period (s)','FontSize',18)
set(gca,'position',[0.130,0.110,0.775,0.68])

title(['Multitrace Features Extraction'],'FontSize',18)

% Print output graph
if (output)
	print -depsc featureout.eps
endif


%---------------------------------------------------------------------%
%                                                                     %
% A.A. 2009/2010 - 2010/2011                                          %
% Original code by Federico Alessandro Ruffinatti                     %
% UniversitÓ degli Studi di Torino - Italy - DBAU - Scienze MFN       %
% Scuola di Dottorato in Neuroscienze - XXV ciclo                     %
%                                                                     %
% Wavelet computation is regarded as a time convolution and it is     %
% implemented as a product in the Fourier transformed domain.         %
% A standard code for this algorithm can be found, for instance,      %
% in WaveLab850 - http://www-stat.stanford.edu/~wavelab/              %
%                                                                     %
% Peaks detection uses a technique that is based on images dilation.  %
% See, for instance, localMaximum.m m-file by Yonathan Nativ          %
% http://www.mathworks.com/matlabcentral/fileexchange/authors/26510/  %
%                                                                     %
%---------------------------------------------------------------------%