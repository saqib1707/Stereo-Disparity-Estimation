function [cieq, ceq] = constraints(x, disp_patch)
    cieq = [];
    ceq = equality_constraints(x, disp_patch);
end