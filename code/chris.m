function res = eb_beam()

clear all

syms w x wx wxx wxxx b c1 c2 c3 c4 L bL

 

w    = c1*cos(b*x) + c2*sin(b*x) + c3*cosh(b*x) + c4*sinh(b*x)
wx   = diff(w,x)
wxx  = diff(w,x,2)
wxxx = diff(w,x,3)

 

% apply boundary conditions

ws = subs(w, {x}, {0})
wxs = subs(wx, {x}, {0})
wxxs = subs (wxx, {x}, {L})
wxxxs = subs (wxxx, {x}, {L})

for e = {ws wxs wxxs wxxxs}
    for c = {c1 c2 c3 c4}
        coeffs(e,c)
    end
end

pause

% need to group coefficients of c1 c2 c3 c4 into a square matrix
% how can this be done? need some kind of collect

 

% by inspection
[c t] = coeffs(wxxxs, c1)
[c t] = coeffs(wxxxs, c2)
[c t] = coeffs(wxxxs, c3)
[c t] = coeffs(wxxxs, c4)
c = coeffs(ws, c4)
pause
 

char_det = [ 1 0 1 0; 0 b 0 b; ...

        -cos(b*L)*b^2  -sin(b*L)*b^2  cosh(b*L)*b^2  sinh(b*L)*b^2; ...

        sin(b*L)*b^3   -cos(b*L)*b^3  sinh(b*L)*b^3  cosh(b*L)*b^3]

   

 

 % det = 0 yields characteristic eqn in which c's .ne. 0

char_eqn = simplify( det(char_det) )

char_eqn = (1+cos(bL)*cosh(bL))

f = matlabFunction(char_eqn)
 

% need string to num?

 

 

bln = fzero(f, 0)

 

 

%solve (char_eqn, b)

 