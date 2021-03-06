function [Q,obj,fd1,fd2]=q_centroid(A1,A2,f,t1,t2,Qmax,Qmin)
% Q_centroid: estimate Q from matching centroid frequecies
%
% [Q,obj,fd1,fd2]=Q_centroid(A1,A2,f,t1,t2,Qmax,Qmin)
%
% It is assumed that A2 is related to A1 through the model
% A2=A1*T*exp(-pi*f*(t2-t1)/Q), where T and Q are real, positive, scalars
% to be determined. T represents frequency independent loss while Q
% parameterizes the frequency-dependent attenuation. The centroid
% frequency, also known as the dominant frequency is defined by
% fc=sum(f.*A.^2)/sum(A.^2) for spectrum A. Let fc2 be the centroid
% frequency for spectrum A2 and consider the spectrum
% Aq=A1*exp(-pi*f*(t2-t1)/Q) which has centroic frequency fc. By letting Q
% range over all integer valies from Qmin to Qmax, we can find the
% minimimum value of the norm((fc-fc2).*Qtest) where Qtest=Qmin:Qmax. The
% value of Q at the minimum is returned as the estimated Q. A virtue of
% this method is that is does not requite estimation of T. The method fails
% if fc1 is less than fc2.
%
% A1 ... amplitude spectrum at time t1 (A1 must never vanish)
% A2 ... amplitude spectrum at time t2 (Note t2 should be greater than t1)
% f  ... frequency coordinate vector for A1 and A2. 
%NOTE: A1, A2, and f must be real-valued vectors of identical size
% t1 ... time at which the spectrum A1 was measured
% t2 ... time at which the spectrum t2 was measured
% Qmax ... maximum value of Q in the search
% *********** default Qmax=250 ************
% Qmin ... minimum value of Q in the search
% *********** default Qmin=5 ***********
%
% Q       ... estimated Q value
% obj     ... objective function
% fc1     ... dominant frequency of spectrum A1
% fc2     ... dominant frequency of spectrum A2
%NOTE: obj has length Qmin:Qmax  
%
% by G.F. Margrave, 2014
%
% NOTE: It is illegal for you to use this software for a purpose other
% than non-profit education or research UNLESS you are employed by a CREWES
% Project sponsor. By using this software, you are agreeing to the terms
% detailed in this software's Matlab source file.
 
% BEGIN TERMS OF USE LICENSE
%
% This SOFTWARE is maintained by the CREWES Project at the Department
% of Geology and Geophysics of the University of Calgary, Calgary,
% Alberta, Canada.  The copyright and ownership is jointly held by 
% its author (identified above) and the CREWES Project.  The CREWES 
% project may be contacted via email at:  crewesinfo@crewes.org
% 
% The term 'SOFTWARE' refers to the Matlab source code, translations to
% any other computer language, or object code
%
% Terms of use of this SOFTWARE
%
% 1) Use of this SOFTWARE by any for-profit commercial organization is
%    expressly forbidden unless said organization is a CREWES Project
%    Sponsor.
%
% 2) A CREWES Project sponsor may use this SOFTWARE under the terms of the 
%    CREWES Project Sponsorship agreement.
%
% 3) A student or employee of a non-profit educational institution may 
%    use this SOFTWARE subject to the following terms and conditions:
%    - this SOFTWARE is for teaching or research purposes only.
%    - this SOFTWARE may be distributed to other students or researchers 
%      provided that these license terms are included.
%    - reselling the SOFTWARE, or including it or any portion of it, in any
%      software that will be resold is expressly forbidden.
%    - transfering the SOFTWARE in any form to a commercial firm or any 
%      other for-profit organization is expressly forbidden.
%
% END TERMS OF USE LICENSE
if(nargin<7)
    Qmin=5;
end
if(nargin<6)
    Qmax=250;
end

if(any(size(A1)~=size(A2)))
    error('A1 and A2 must be the same size')
end
if(any(size(f)~=size(A1)))
    error('size of f must be the same as A1 and A2')
end

Qtest=Qmin:Qmax;
delt=t2-t1;
fd1=sum(f.*A1.^2)/sum(A1.^2);
fd2=sum(f.*A2.^2)/sum(A2.^2);
if(fd1>fd2)
    fdtest=zeros(size(Qtest));
    for k=1:length(Qtest)
        Atest=A1.*exp(-pi*f*delt/Qtest(k));
        fdtest(k)=sum(f.*Atest.^2)/sum(Atest.^2);
    end
    %find where fdtest is closest to fd2;
    obj=Qtest.*(fdtest-fd2).^2;%objective function
    [omin,imin]=min(obj);
    Q=Qtest(imin);
end