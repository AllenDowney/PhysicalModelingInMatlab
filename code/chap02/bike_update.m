% Update the state of the bike system.
% Preconditon: b and c contains the number of bikes.
% Postconditon: values of b and c are updated.

b_to_c = round(0.05*b) - round(0.03*c);
b = b - b_to_c
c = c + b_to_c
