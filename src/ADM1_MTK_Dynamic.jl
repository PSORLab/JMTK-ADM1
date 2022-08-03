#--ANAEROBIC DIGESTION ModelingToolkit Model----------------------------------------------------------------
#--Samuel Degnan-Morgenstern ----------------------------------------------------------------------------------
#--06/30/2022--------------------------------------------------------------------------------------------------
#--PI: Dr. Matthew Stuber--------------------------------------------------------------------------------------
#--Based on ADM1-----------------------------------------------------------------------------------------------
#--Full Model details available in Rosen 2006: "Aspects on ADM1 implementation within the BSM2 framework"------
#--ModelingToolkit version v8.15.1, DifferentialEquations v7.1.0, Symbolics v4.8.3----------------------------
#--------------------------------------------------------------------------------------------------------------
#Import Packages
using DifferentialEquations,Plots,LinearAlgebra,ModelingToolkit,IfElse
using DelimitedFiles
using Symbolics:@register_symbolic,scalarize
#--------------------------------------------------------------------------------------
#SET UP INFLUENT DATA STREAMS
#Specify relevant time range for influent data
t_r=0.0:1/96:280.0 # Units of days, sampled every 15 minutes
#Import and divide digester influent data - taken from PyADM1 implementation [2]
in_dat_full=readdlm("digester_influent.csv",',',Float64)';
in_dat =in_dat_full[2:end-1,:];
q_dat=in_dat_full[end,:];
#Create 0th order interpolation functions and register with symbolics (In tests cubic spline interpolation was computationally prohibitive)
#All functions return values with units of (kgCOD·m–3)
function S_su_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[1,cdat]
end; @register_symbolic S_su_in_itp(time)
function S_aa_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[2,cdat]
end; @register_symbolic S_aa_in_itp(time)
function S_fa_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[3,cdat]
end; @register_symbolic S_fa_in_itp(time)
function S_va_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[4,cdat]
end; @register_symbolic S_va_in_itp(time)
function S_bu_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[5,cdat]
end; @register_symbolic S_bu_in_itp(time)
function S_pro_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[6,cdat]
end; @register_symbolic S_pro_in_itp(time)
function S_ac_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[7,cdat]
end; @register_symbolic S_ac_in_itp(time)
function S_h2_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[8,cdat]
end; @register_symbolic S_h2_in_itp(time)
function S_ch4_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[9,cdat]
end; @register_symbolic S_ch4_in_itp(time)
function S_IC_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[10,cdat]
end; @register_symbolic S_IC_in_itp(time)
function S_IN_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[11,cdat]
end; @register_symbolic S_IN_in_itp(time)
function S_I_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[12,cdat]
end; @register_symbolic S_I_in_itp(time)
function X_c_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[13,cdat]
end; @register_symbolic X_c_in_itp(time)
function X_ch_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[14,cdat]
end; @register_symbolic X_ch_in_itp(time)
function X_pr_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[15,cdat]
end; @register_symbolic X_pr_in_itp(time)
function X_li_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[16,cdat]
end; @register_symbolic X_li_in_itp(time)
function X_su_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[17,cdat]
end; @register_symbolic X_su_in_itp(time)
function X_aa_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[18,cdat]
end; @register_symbolic X_aa_in_itp(time)
function X_fa_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[19,cdat]
end; @register_symbolic X_fa_in_itp(time)
function X_c4_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[20,cdat]
end; @register_symbolic X_c4_in_itp(time)
function X_pro_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[21,cdat]
end; @register_symbolic X_pro_in_itp(time)
function X_ac_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[22,cdat]
end; @register_symbolic X_ac_in_itp(time)
function X_h2_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[23,cdat]
end; @register_symbolic X_h2_in_itp(time)
function X_I_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[24,cdat]
end; @register_symbolic X_I_in_itp(time)
function S_cat_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[25,cdat]
end; @register_symbolic S_cat_in_itp(time)
function S_an_in_itp(time)
    true_time=round(Int,time/(1/96))+1; cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time)); return in_dat[26,cdat]
end; @register_symbolic S_an_in_itp(time)
function q_itp(time)
    true_time=round(Int,time/(1/96))+1;
    cdat=IfElse.ifelse(true_time<1,1,IfElse.ifelse(true_time>26881,26881,true_time))
    return q_dat[cdat]
end;
@register_symbolic q_itp(time)
#--------------------------------------------------------------------------------------
#Define and register hill function used in calculating inhibition factors
function calc_I_pH_hill_s(n,S_H_plus,pH_LL,pH_UL)
    K_pH = 10^-((pH_LL + pH_UL)/2)
    return K_pH^n/(S_H_plus^n + K_pH^n)
end
@register_symbolic calc_I_pH_hill_s(n,S_H_plus,pH_LL,pH_UL)
#--------------------------------------------------------------------------------------
#Define Operating Parameters
@parameters V_liq, V_gas,T_op
#Define Physical Conditions
@parameters P_atm, R, p_gas_h2o
#Define Carbon Stoichiometry Parameters
@parameters C_xc,C_sI,C_ch,C_pr,C_li,C_xI,C_su,C_aa,C_fa,C_bu,C_pro,C_ac,C_bac,C_va,C_ch4
#Define yields of product on substrate
@parameters f_sI_xc,f_xI_xc,f_ch_xc,f_pr_xc,f_li_xc,f_fa_li,f_h2_su,f_bu_su,f_pro_su,f_ac_su,f_h2_aa,f_va_aa,f_bu_aa,f_pro_aa,f_ac_aa
#Define Nitrogen Stoichiometry Parameters
@parameters N_xc,N_I,N_aa,N_bac
#Define yields of biomass on substrate
@parameters Y_su,Y_aa,Y_fa,Y_c4,Y_pro,Y_ac,Y_h2
#Define kinetic parameters
@parameters k_dis,k_hyd_ch,k_hyd_pr,k_hyd_li,k_dec_all,k_m_su,k_m_aa,k_m_fa,k_m_c4,k_m_pro,k_m_ac,k_m_h2,k_p,k_La
@parameters K_S_IN,K_S_su,K_S_aa,K_S_fa,K_I_H2_fa,K_S_c4,K_I_H2_c4,K_S_pro,K_I_H2_pro,K_S_ac,K_I_NH3,K_S_h2,K_W,K_a_va,K_a_bu,K_a_pro,K_a_ac,K_a_co2,K_a_IN,K_H_co2,K_H_ch4,K_H_h2
#Define pH limits
@parameters pH_UL_aa,pH_LL_aa,pH_UL_ac,pH_LL_ac,pH_UL_h2,pH_LL_h2
#--------------------------------------------------------------------------------------
#Define state variables (all functions of time)
@variables t, S_su(t),S_aa(t),S_fa(t),S_va(t),S_bu(t),S_pro(t),S_ac(t),S_h2(t),
S_ch4(t),S_IC(t),S_IN(t),S_I(t),X_c(t),X_ch(t),X_pr(t),X_li(t),
X_su(t),X_aa(t),X_fa(t),X_c4(t),X_pro(t),X_ac(t),X_h2(t),X_I(t),
S_cat(t),S_an(t),S_H_plus(t),S_gas_h2(t),S_gas_ch4(t),S_gas_co2(t)
#Define auxiliary variables
@variables p_gas_h2(t), p_gas_ch4(t), p_gas_co2(t), P_gas(t), q_gas(t), s_va_minus(t), s_bu_minus(t), s_pro_minus(t), s_ac_minus(t), s_hco3_minus(t), s_nh3(t), s_nh4_plus(t),
I_pH_aa(t),I_pH_ac(t),I_pH_h2(t),I_IN_lim(t),I_h2_fa(t),I_h2_c4(t),I_h2_pro(t),I_nh3(t),I_5_6(t),I_7(t),I_8_9(t),I_10(t),I_11(t),I_12(t),subsum(t),pH(t)
@variables s_1(t),s_2(t),s_3(t),s_4(t),s_5(t),s_6(t),s_7(t),s_8(t),s_9(t),s_10(t),s_11(t),s_12(t),s_13(t)
@variables ρ_bc_1(t),ρ_bc_2(t),ρ_bc_3(t),ρ_bc_4(t),ρ_bc_5(t),ρ_bc_6(t),ρ_bc_7(t),ρ_bc_8(t),ρ_bc_9(t),ρ_bc_10(t),
ρ_bc_11(t),ρ_bc_12(t),ρ_bc_13(t),ρ_bc_14(t),ρ_bc_15(t),ρ_bc_16(t),ρ_bc_17(t),ρ_bc_18(t),ρ_bc_19(t)
@variables ρ_T_1(t),ρ_T_2(t),ρ_T_3(t)
@variables reac_1(t),reac_2(t),reac_3(t),reac_4(t),reac_5(t),reac_6(t),reac_7(t),reac_8(t),reac_9(t),reac_10(t), reac_11(t),reac_12(t),
reac_13(t),reac_14(t),reac_15(t),reac_16(t),reac_17(t),reac_18(t),reac_19(t),reac_20(t),reac_21(t),reac_22(t),reac_23(t),reac_24(t) 
#Define Influent Variables
@variables S_su_in(t),S_aa_in(t),S_fa_in(t),S_va_in(t),S_bu_in(t),S_pro_in(t),S_ac_in(t),S_h2_in(t),S_ch4_in(t),S_IC_in(t),S_IN_in(t),S_I_in(t),
X_c_in(t),X_ch_in(t),X_pr_in(t),X_li_in(t),X_su_in(t),X_aa_in(t),X_fa_in(t),X_c4_in(t),X_pro_in(t),X_ac_in(t),X_h2_in(t),X_I_in(t),S_cat_in(t),S_an_in(t)
@variables q(t)
#Register differential with respect to time t
D = Differential(t)
#--------------------------------------------------------------------------------------
#Function to create instance of ADM1 Model
function ADM1_factory(;name)
    #Define Operating Parameters
    @parameters V_liq, V_gas,T_op
    #Define Physical Conditions
    @parameters P_atm, R, p_gas_h2o
    #Define Carbon Stoichiometry Parameters
    @parameters C_xc,C_sI,C_ch,C_pr,C_li,C_xI,C_su,C_aa,C_fa,C_bu,C_pro,C_ac,C_bac,C_va,C_ch4
    #Define yields of product on substrate
    @parameters f_sI_xc,f_xI_xc,f_ch_xc,f_pr_xc,f_li_xc,f_fa_li,f_h2_su,f_bu_su,f_pro_su,f_ac_su,f_h2_aa,f_va_aa,f_bu_aa,f_pro_aa,f_ac_aa
    #Define Nitrogen Stoichiometry Parameters
    @parameters N_xc,N_I,N_aa,N_bac
    #Define yields of biomass on substrate
    @parameters Y_su,Y_aa,Y_fa,Y_c4,Y_pro,Y_ac,Y_h2
    #Define kinetic parameters
    @parameters k_dis,k_hyd_ch,k_hyd_pr,k_hyd_li,k_dec_all,k_m_su,k_m_aa,k_m_fa,k_m_c4,k_m_pro,k_m_ac,k_m_h2,k_p,k_La
    @parameters K_S_IN,K_S_su,K_S_aa,K_S_fa,K_I_H2_fa,K_S_c4,K_I_H2_c4,K_S_pro,K_I_H2_pro,K_S_ac,K_I_NH3,K_S_h2,K_W,K_a_va,K_a_bu,K_a_pro,K_a_ac,K_a_co2,K_a_IN,K_H_co2,K_H_ch4,K_H_h2
    #Define pH limits
    @parameters pH_UL_aa,pH_LL_aa,pH_UL_ac,pH_LL_ac,pH_UL_h2,pH_LL_h2
    #--------------------------------------------------------------------------------------
    #Define state variables (all functions of time)
    @variables t, S_su(t),S_aa(t),S_fa(t),S_va(t),S_bu(t),S_pro(t),S_ac(t),S_h2(t),
    S_ch4(t),S_IC(t),S_IN(t),S_I(t),X_c(t),X_ch(t),X_pr(t),X_li(t),
    X_su(t),X_aa(t),X_fa(t),X_c4(t),X_pro(t),X_ac(t),X_h2(t),X_I(t),
    S_cat(t),S_an(t),S_H_plus(t),S_gas_h2(t),S_gas_ch4(t),S_gas_co2(t)
    #Define auxiliary variables
    @variables p_gas_h2(t), p_gas_ch4(t), p_gas_co2(t), P_gas(t), q_gas(t), s_va_minus(t), s_bu_minus(t), s_pro_minus(t), s_ac_minus(t), s_hco3_minus(t), s_nh3(t), s_nh4_plus(t),
    I_pH_aa(t),I_pH_ac(t),I_pH_h2(t),I_IN_lim(t),I_h2_fa(t),I_h2_c4(t),I_h2_pro(t),I_nh3(t),I_5_6(t),I_7(t),I_8_9(t),I_10(t),I_11(t),I_12(t),subsum(t),pH(t)
    @variables s_1(t),s_2(t),s_3(t),s_4(t),s_5(t),s_6(t),s_7(t),s_8(t),s_9(t),s_10(t),s_11(t),s_12(t),s_13(t)
    @variables ρ_bc_1(t),ρ_bc_2(t),ρ_bc_3(t),ρ_bc_4(t),ρ_bc_5(t),ρ_bc_6(t),ρ_bc_7(t),ρ_bc_8(t),ρ_bc_9(t),ρ_bc_10(t),
    ρ_bc_11(t),ρ_bc_12(t),ρ_bc_13(t),ρ_bc_14(t),ρ_bc_15(t),ρ_bc_16(t),ρ_bc_17(t),ρ_bc_18(t),ρ_bc_19(t)
    @variables ρ_T_1(t),ρ_T_2(t),ρ_T_3(t)
    @variables reac_1(t),reac_2(t),reac_3(t),reac_4(t),reac_5(t),reac_6(t),reac_7(t),reac_8(t),reac_9(t),reac_10(t), reac_11(t),reac_12(t),
    reac_13(t),reac_14(t),reac_15(t),reac_16(t),reac_17(t),reac_18(t),reac_19(t),reac_20(t),reac_21(t),reac_22(t),reac_23(t),reac_24(t) 
    #Define Influent Variables
    @variables S_su_in(t),S_aa_in(t),S_fa_in(t),S_va_in(t),S_bu_in(t),S_pro_in(t),S_ac_in(t),S_h2_in(t),S_ch4_in(t),S_IC_in(t),S_IN_in(t),S_I_in(t),
    X_c_in(t),X_ch_in(t),X_pr_in(t),X_li_in(t),X_su_in(t),X_aa_in(t),X_fa_in(t),X_c4_in(t),X_pro_in(t),X_ac_in(t),X_h2_in(t),X_I_in(t),S_cat_in(t),S_an_in(t)
    @variables q(t)
    #Register differential with respect to time t
    D = Differential(t)
    #Create ADM1 system of equations
    eqs = [
    #Set up influent conditions
    S_su_in ~ S_su_in_itp(t),
    S_aa_in ~ S_aa_in_itp(t),
    S_fa_in ~ S_fa_in_itp(t),
    S_va_in ~ S_va_in_itp(t),
    S_bu_in ~ S_bu_in_itp(t),
    S_pro_in ~ S_pro_in_itp(t),
    S_ac_in ~ S_ac_in_itp(t),
    S_h2_in ~ S_h2_in_itp(t),
    S_ch4_in ~ S_ch4_in_itp(t),
    S_IC_in ~ S_IC_in_itp(t),
    S_IN_in ~ S_IN_in_itp(t),
    S_I_in ~ S_I_in_itp(t),
    X_c_in ~ X_c_in_itp(t),
    X_ch_in ~ X_ch_in_itp(t),
    X_pr_in ~ X_pr_in_itp(t),
    X_li_in ~ X_li_in_itp(t),
    X_su_in ~ X_su_in_itp(t),
    X_aa_in ~ X_aa_in_itp(t),
    X_fa_in ~ X_fa_in_itp(t),
    X_c4_in ~ X_c4_in_itp(t),
    X_pro_in ~ X_pro_in_itp(t),
    X_ac_in ~ X_ac_in_itp(t),
    X_h2_in ~ X_h2_in_itp(t),
    X_I_in ~ X_I_in_itp(t),
    S_cat_in ~ S_cat_in_itp(t),
    S_an_in ~ S_an_in_itp(t),
    q ~ q_itp(t),
    pH ~ -log10(S_H_plus),
    #Set up auxiliary gas phase variables
    p_gas_h2 ~ S_gas_h2*R*T_op/16, #partial pressure of h2 (bar)
    p_gas_ch4 ~ S_gas_ch4*R*T_op/64, #partial pressure of methane (bar)
    p_gas_co2 ~ S_gas_co2*R*T_op, # partial pressure of co2 (bar)
    P_gas ~ p_gas_h2 + p_gas_ch4 + p_gas_co2 + p_gas_h2o, #total gas pressure (bar)
    q_gas ~ k_p*(P_gas - P_atm), #gas volumetric flow rate 
    #Define ion substates
    s_va_minus ~ K_a_va*S_va/(K_a_va+S_H_plus), #valerate ion
    s_bu_minus ~ K_a_bu*S_bu/(K_a_bu+S_H_plus), #butyrate ion
    s_pro_minus ~ K_a_pro*S_pro/(K_a_pro+S_H_plus), #propionate ion
    s_ac_minus ~ K_a_ac*S_ac/(K_a_ac+S_H_plus), #acetate ion
    s_hco3_minus ~ K_a_co2*S_IC/(K_a_co2+S_H_plus), #carbonate ion
    s_nh3 ~ K_a_IN*S_IN/(K_a_IN+S_H_plus), #ammonia
    s_nh4_plus ~ S_IN - s_nh3,#ammonium
    I_pH_aa ~ calc_I_pH_hill_s(3/(pH_UL_aa-pH_LL_aa),S_H_plus,pH_LL_aa,pH_UL_aa), #amino acid inhibition
    I_pH_ac ~ calc_I_pH_hill_s(3/(pH_UL_ac-pH_LL_ac),S_H_plus,pH_LL_ac,pH_UL_ac), #acetate inhibition
    I_pH_h2 ~ calc_I_pH_hill_s(3/(pH_UL_h2-pH_LL_h2),S_H_plus,pH_LL_h2,pH_UL_h2), #hydrogen inhibition
    I_IN_lim ~ 1.0/(1.0+K_S_IN/S_IN), #Inorganic nitrogen inhibition
    I_h2_fa ~ 1.0/(1.0+S_h2/K_I_H2_fa),#hyrogen fatty acid inhibition
    I_h2_c4 ~ 1.0/(1.0+S_h2/K_I_H2_c4),#hydrogen c4 inhibition
    I_h2_pro ~ 1.0/(1.0+S_h2/K_I_H2_pro), #hydrogen propionate inhibiton
    I_nh3 ~ 1.0/(1.0+s_nh3/K_I_NH3), #ammonia inhibition 
    I_5_6 ~ I_pH_aa*I_IN_lim, #inhibition for processes 5 & 6
    I_7 ~ I_pH_aa*I_IN_lim*I_h2_fa, #inhibition for process 7
    I_8_9 ~ I_pH_aa*I_IN_lim*I_h2_c4, #inhibition for processes 5 & 6
    I_10 ~ I_pH_aa*I_IN_lim*I_h2_pro, #inhibition for process 10
    I_11 ~ I_pH_ac*I_IN_lim*I_nh3, #inhibition for process 11
    I_12 ~ I_pH_h2*I_IN_lim, #inhibition for process 12
    #Intermediate states for process 10
    s_1 ~ -C_xc+f_sI_xc*C_sI+f_ch_xc*C_ch+f_pr_xc*C_pr+f_li_xc*C_li+f_xI_xc*C_xI,
    s_2 ~ -C_ch+C_su,
    s_3 ~ -C_pr+C_aa,
    s_4 ~ -C_li+(1-f_fa_li)*C_su+f_fa_li*C_fa,
    s_5 ~ -C_su+(1-Y_su)*(f_bu_su*C_bu+f_pro_su*C_pro + f_ac_su*C_ac) + Y_su*C_bac,
    s_6 ~ -C_aa+(1-Y_aa)*(f_va_aa*C_va+f_bu_aa*C_bu+f_pro_aa*C_pro + f_ac_aa*C_ac) + Y_aa*C_bac,
    s_7 ~ -C_fa+(1-Y_fa)*.7*C_ac+Y_fa*C_bac,
    s_8 ~ -C_va+(1-Y_c4)*.54*C_pro+(1-Y_c4)*.31*C_ac+Y_c4*C_bac,
    s_9 ~ -C_bu+(1-Y_c4)*.8*C_ac+Y_c4*C_bac,
    s_10 ~ -C_pro+(1-Y_pro)*.57*C_ac+Y_pro*C_bac,
    s_11 ~ -C_ac+(1-Y_ac)*C_ch4+Y_ac*C_bac,
    s_12 ~ (1-Y_h2)*C_ch4+Y_h2*C_bac,
    s_13 ~ -C_bac+C_xc,
    #Biochemical process rate terms 
    ρ_bc_1 ~ k_dis*X_c,
    ρ_bc_2 ~ k_hyd_ch*X_ch,
    ρ_bc_3 ~ k_hyd_pr*X_pr,
    ρ_bc_4 ~ k_hyd_li*X_li,
    ρ_bc_5 ~ k_m_su*S_su*X_su*I_5_6/(K_S_su+S_su),
    ρ_bc_6 ~ k_m_aa*S_aa*X_aa*I_5_6/(K_S_aa+S_aa),
    ρ_bc_7 ~ k_m_fa*S_fa*X_fa*I_7/(K_S_fa+S_fa),
    ρ_bc_8 ~ k_m_c4*(S_va/(K_S_c4+S_va))*X_c4*(S_va/(S_bu+S_va+1e-6))*I_8_9,
    ρ_bc_9 ~ k_m_c4*(S_bu/(K_S_c4+S_bu))*X_c4*(S_bu/(S_va+S_bu+1e-6))*I_8_9,
    ρ_bc_10 ~ k_m_pro*(S_pro/(K_S_pro+S_pro))*X_pro*I_10,
    ρ_bc_11 ~ k_m_ac*(S_ac/(K_S_ac+S_ac))*X_ac*I_11,
    ρ_bc_12 ~ k_m_h2*(S_h2/(K_S_h2+S_h2))*X_h2*I_12,
    ρ_bc_13 ~ k_dec_all*X_su,
    ρ_bc_14 ~ k_dec_all*X_aa,
    ρ_bc_15 ~ k_dec_all*X_fa,
    ρ_bc_16 ~ k_dec_all*X_c4,
    ρ_bc_17 ~ k_dec_all*X_pro,
    ρ_bc_18 ~ k_dec_all*X_ac,
    ρ_bc_19 ~ k_dec_all*X_h2,
    subsum ~ ρ_bc_13 + ρ_bc_14 + ρ_bc_15 + ρ_bc_16 + ρ_bc_17 + ρ_bc_18 + ρ_bc_19,
    #Gas Transfer process rate terms
    ρ_T_1 ~ k_La*(S_h2-16*K_H_h2*p_gas_h2),
    ρ_T_2 ~ k_La*(S_ch4-64*K_H_ch4*p_gas_ch4),
    ρ_T_3 ~ k_La*((S_IC-s_hco3_minus)-K_H_co2*p_gas_co2),
    #Reaction terms
    reac_1 ~  ρ_bc_2+(1-f_fa_li)*ρ_bc_4-ρ_bc_5,
    reac_2 ~  ρ_bc_3 - ρ_bc_6,
    reac_3 ~  f_fa_li*ρ_bc_4 - ρ_bc_7,
    reac_4 ~  (1-Y_aa)*f_va_aa*ρ_bc_6-ρ_bc_8,
    reac_5 ~  (1-Y_su)*f_bu_su*ρ_bc_5 + (1-Y_aa)*f_bu_aa*ρ_bc_6-ρ_bc_9,
    reac_6 ~ (1-Y_su)*f_pro_su*ρ_bc_5 + (1-Y_aa)*f_pro_aa*ρ_bc_6+(1-Y_c4)*.54*ρ_bc_8-ρ_bc_10,
    reac_7 ~ (1-Y_su)*f_ac_su*ρ_bc_5 + (1-Y_aa)*f_ac_aa*ρ_bc_6+(1-Y_fa)*.7*ρ_bc_7+(1-Y_c4)*.31*ρ_bc_8+(1-Y_c4)*.8*ρ_bc_9+(1-Y_pro)*.57*ρ_bc_10-ρ_bc_11,
    reac_8 ~ (1-Y_su)*f_h2_su*ρ_bc_5 + (1-Y_aa)*f_h2_aa*ρ_bc_6+(1-Y_fa)*.3*ρ_bc_7+(1-Y_c4)*.15*ρ_bc_8+(1-Y_c4)*.2*ρ_bc_9+(1-Y_pro)*.43*ρ_bc_10-ρ_bc_12-ρ_T_1,
    reac_9 ~  (1-Y_ac)*ρ_bc_11+(1-Y_h2)*ρ_bc_12-ρ_T_2,
    reac_10 ~   -(s_1*ρ_bc_1 + s_2*ρ_bc_2 + s_3*ρ_bc_3 + s_4*ρ_bc_4 + s_5*ρ_bc_5 + s_6*ρ_bc_6 + s_7*ρ_bc_7 + s_8*ρ_bc_8 + s_9*ρ_bc_9 + s_10*ρ_bc_10 + s_11*ρ_bc_11 + s_12*ρ_bc_12)-s_13*subsum-ρ_T_3,
    reac_11 ~  -Y_su*N_bac*ρ_bc_5+(N_aa-Y_aa*N_bac)*ρ_bc_6-Y_fa*N_bac*ρ_bc_7-Y_c4*N_bac*ρ_bc_8-Y_c4*N_bac*ρ_bc_9-Y_pro*N_bac*ρ_bc_10-Y_ac*N_bac*ρ_bc_11-Y_h2*N_bac*ρ_bc_12+(N_bac-N_xc)*subsum+(N_xc-f_xI_xc*N_I-f_sI_xc*N_I-f_pr_xc*N_aa)*ρ_bc_1,
    reac_12 ~ f_sI_xc*ρ_bc_1,
    reac_13 ~  -ρ_bc_1 + subsum,
    reac_14 ~ f_ch_xc*ρ_bc_1 - ρ_bc_2,
    reac_15 ~ f_pr_xc*ρ_bc_1 - ρ_bc_3,
    reac_16 ~ f_li_xc*ρ_bc_1 - ρ_bc_4,
    reac_17 ~  Y_su*ρ_bc_5- ρ_bc_13,
    reac_18 ~ Y_aa*ρ_bc_6- ρ_bc_14,
    reac_19 ~ Y_fa*ρ_bc_7- ρ_bc_15,
    reac_20 ~ Y_c4*ρ_bc_8+Y_c4*ρ_bc_9-ρ_bc_16,
    reac_21 ~  Y_pro*ρ_bc_10- ρ_bc_17,
    reac_22 ~  Y_ac*ρ_bc_11- ρ_bc_18,
    reac_23 ~  Y_h2*ρ_bc_12- ρ_bc_19,
    reac_24 ~  f_xI_xc*ρ_bc_1,
    #ODE / Algebraic state terms (main model)
    D(S_su) ~ (q/V_liq)*(S_su_in - S_su) + reac_1, #Monosaccharides (kgCOD·m–3)
    D(S_aa) ~ (q/V_liq)*(S_aa_in - S_aa) + reac_2, #Amino acids (kgCOD·m–3)
    D(S_fa) ~ (q/V_liq)*(S_fa_in - S_fa) + reac_3, #Long chain fatty acids (LCFA) (kgCOD·m–3)
    D(S_va) ~ (q/V_liq)*(S_va_in - S_va) + reac_4, #Total valerate (kgCOD·m–3)
    D(S_bu) ~ (q/V_liq)*(S_bu_in - S_bu) + reac_5, #Total butyrate (kgCOD·m–3)
    D(S_pro) ~ (q/V_liq)*(S_pro_in - S_pro) + reac_6, #Total propionate (kgCOD·m–3)
    D(S_ac) ~ (q/V_liq)*(S_ac_in - S_ac) + reac_7, #Total acetate (kgCOD·m–3)
    0 ~ (q/V_liq)*(S_h2_in - S_h2) + reac_8, #Dissolved Hydrogen gas (algebraic term) (kgCOD·m–3)
    D(S_ch4) ~ (q/V_liq)*(S_ch4_in - S_ch4) + reac_9, #Dissolved Methane Gas (kgCOD·m–3)
    D(S_IC) ~ (q/V_liq)*(S_IC_in - S_IC) + reac_10, #Inorganic carbon (kgCOD·m–3)
    D(S_IN) ~ (q/V_liq)*(S_IN_in - S_IN) + reac_11, #Inorganic nitrogen (kgCOD·m–3)
    D(S_I) ~ (q/V_liq)*(S_I_in - S_I) + reac_12, #soluble inerts (kgCOD·m–3)
    D(X_c) ~ (q/V_liq)*(X_c_in - X_c) + reac_13, #Composites (kgCOD·m–3)
    D(X_ch) ~ (q/V_liq)*(X_ch_in - X_ch) + reac_14, #Carbohydrates (kgCOD·m–3)
    D(X_pr) ~ (q/V_liq)*(X_pr_in - X_pr) + reac_15, #Proteins (kgCOD·m–3)
    D(X_li) ~ (q/V_liq)*(X_li_in - X_li) + reac_16, #Lipids (kgCOD·m–3)
    D(X_su) ~ (q/V_liq)*(X_su_in - X_su) + reac_17, #Sugar Degraders (kgCOD·m–3)
    D(X_aa) ~ (q/V_liq)*(X_aa_in - X_aa) + reac_18, #Amino acid degraders (kgCOD·m–3)
    D(X_fa) ~ (q/V_liq)*(X_fa_in - X_fa) + reac_19, #LCFA degraders (kgCOD·m–3)
    D(X_c4) ~ (q/V_liq)*(X_c4_in - X_c4) + reac_20, #Valerate and butyrate degraders (kgCOD·m–3)
    D(X_pro) ~ (q/V_liq)*(X_pro_in - X_pro) + reac_21, #Propionate Degraders (kgCOD·m–3)
    D(X_ac) ~ (q/V_liq)*(X_ac_in - X_ac) + reac_22, #Acetate Degraders (kgCOD·m–3)
    D(X_h2) ~ (q/V_liq)*(X_h2_in - X_h2) + reac_23, #Hydrogen Degraders (kgCOD·m–3)
    D(X_I) ~ (q/V_liq)*(X_I_in - X_I) + reac_24, #Particulate Inerts (kgCOD·m–3)
    D(S_cat) ~ (q/V_liq)*(S_cat_in - S_cat), #Cations (kgCOD·m–3)
    D(S_an) ~ (q/V_liq)*(S_an_in - S_an), #Anions (kgCOD·m–3)
    0 ~ S_cat+s_nh4_plus+S_H_plus-s_hco3_minus-s_ac_minus/64-s_pro_minus/112-s_bu_minus/160-s_va_minus/208-K_W/S_H_plus-S_an, #Ion/Charge balance (used to solve for hydrogen ion)
    D(S_gas_h2) ~ -S_gas_h2*q_gas/V_gas+ρ_T_1*V_liq/V_gas, #Hydrogen gas (kgCOD·m–3)
    D(S_gas_ch4) ~ -S_gas_ch4*q_gas/V_gas+ρ_T_2*V_liq/V_gas, #Methane gas (kgCOD·m–3)
    D(S_gas_co2) ~ -S_gas_co2*q_gas/V_gas+ρ_T_3*V_liq/V_gas #Carbon dioxide gas (kgCOD·m–3)
    ]
    return ODESystem(eqs;name)
end
#--------------------------------------------------------------------------------------
#Register ADM1 equations in modeling toolkit and run structural simplifications
@named ADM1_sys = ADM1_factory()
ADM1_simp = structural_simplify(ADM1_sys)
#--------------------------------------------------------------------------------------
#Specify parameter values -> Taken from Rosen 2006 appendix
#Size parameters
size_param=[V_liq=>3400.0,V_gas=>300.0]
#Operational parameters
op_param=[P_atm=>1.013,R=>0.083145,T_op=>308.15,p_gas_h2o=>0.0313*exp(5290*(1/298.15-1/308.15))]
#Carbon stoich parameters
C_param=[C_xc=>0.02786,C_sI=>0.03,C_ch=>0.0313,C_pr=>0.03,C_li=>0.022,C_xI=>0.03,C_su=>0.0313,C_aa=>0.03,C_fa=>0.0217,C_bu=>0.025,C_pro=>0.0268,C_ac=>0.0313,C_bac=>0.0313,C_va=>0.024,C_ch4=>0.0156]
#Yields of product on substrate
f_param=[f_sI_xc=>0.1,f_xI_xc=>0.2,f_ch_xc=>0.20,f_pr_xc=>0.20,f_li_xc=>0.3,f_fa_li=>0.95,f_h2_su=>0.19,f_bu_su=>0.13,f_pro_su=>0.27,f_ac_su=>0.41,f_h2_aa=>0.06,f_va_aa=>0.23,f_bu_aa=>0.26,f_pro_aa=>0.05,f_ac_aa=>0.40]
#Nitrogen stoich parameters
N_param=[N_xc=>0.0376/14,N_I=>.06/14,N_aa=>0.007,N_bac=>0.08/14]
#Yields of biomass on substrate
Y_parama=[Y_su=>0.1,Y_aa=>0.08,Y_fa=>0.06,Y_c4=>0.06,Y_pro=>0.04,Y_ac=>0.05,Y_h2=>0.06]
#Kinetic parameters
k_param=[k_dis=>0.5,k_hyd_ch=>10.0,k_hyd_pr=>10.0,k_hyd_li=>10.0,k_dec_all=>0.02,k_m_su=>30.0,k_m_aa=>50.0,k_m_fa=>6.0,k_m_c4=>20.0,k_m_pro=>13.0,k_m_ac=>8.0,k_m_h2=>35.0,k_p=>5e4,k_La=>200.0]
K_param=[K_S_IN=>1e-4,K_S_su=>0.5,K_S_aa=>0.3,K_S_fa=>0.4,
K_I_H2_fa=>5e-6,K_S_c4=>0.2,K_I_H2_c4=>1e-5,K_S_pro=>0.1,K_I_H2_pro=>3.5e-6,K_S_ac=>0.15,K_I_NH3=>0.0018,K_S_h2=>7e-6,
K_W=>(10^-14)*exp((55900/(0.083145*100))*((1/298.15)-(1/308.15))),K_a_va=>10^-4.86,K_a_bu=>10^-4.82,K_a_pro=>10^-4.88,K_a_ac=>10^-4.76,
K_a_co2=>(10^-6.35)*exp((7646/(0.083145*100))*((1/298.15)-(1/308.15))),K_a_IN=>(10^-9.25)*exp((51965/(0.083145*100))*((1/298.15)-(1/308.15))),K_H_co2=>0.035*exp((-19410/(0.083145*100))*((1/298.15)-(1/308.15))),K_H_ch4=>0.0014*exp((-14240/(0.083145*100))*((1/298.15)-(1/308.15))),K_H_h2=>7.8e-4*exp((-4180/(0.083145*100))*((1/298.15)-(1/308.15)))]
#pH limits
pH_param=[pH_UL_aa=>5.5,pH_LL_aa=>4.0,pH_UL_ac=>7.0,pH_LL_ac=>6.0,pH_UL_h2=>6.0,pH_LL_h2=>5.0]
#Collect all parameters into total parameter array
param_val=[size_param; op_param; C_param; f_param; N_param; Y_parama; k_param; K_param; pH_param]
#--------------------------------------------------------------------------------------
#Define simulation properties and run simulation
#Provide Timespan
tspan = (0.0,280.0)
#Provide initial conditions from PyADM1 model implementation
u0_d=[S_su=>0.012394,S_aa=>0.0055432,S_fa=>0.10741,S_va=>0.012333,
S_bu=>0.014003,S_pro=>0.017584,S_ac=>0.089315,S_h2=>2.51E-07,S_ch4=>0.05549,
S_IC=>0.095149,S_IN=>0.094468,S_I=>0.13087,X_c=>0.10792,X_ch=>0.020517,
X_pr=>0.08422,X_li=>0.043629,X_su=>0.31222,X_aa=>0.93167,X_fa=>0.33839,
X_c4=>0.33577,X_pro=>0.10112,X_ac=>0.67724,X_h2=>0.28484,X_I=>17.2162,S_cat=>1.08E-47,
S_an=>0.0052101,S_H_plus=>(10^-7.26280735729526),S_gas_h2=>1.10E-05,S_gas_ch4=>1.6535,S_gas_co2=>0.01354];
#Specify ODE Problem for modeling toolkit / differentialequations.jl
prob = ODEProblem(ADM1_simp,u0_d,tspan,param_val)
#Solve problem using RadauIIA5 solver for DAE with mass matrix
#This problem generally requires a 4th or 5th order solver - RadauIIA5 demonstrated the best efficiency thus far 
tol=1e-10; #Problem requires high tolerance for accurate dynamic solutions
@time sol = solve(prob, RadauIIA5(),abstol=tol,reltol=tol,saveat=(1/96))
#--------------------------------------------------------------------------------------
#RUN POST PROCESSING
#Define states of interest
state = [S_su,S_aa,S_fa,S_va,S_bu,S_pro,
S_ac,S_h2,S_ch4,S_IC,S_IN,S_I,
X_c,X_ch,X_pr,X_li,X_su,X_aa,X_fa,
X_c4,X_pro,X_ac,X_h2,X_I,
S_cat,S_an,S_H_plus,
s_va_minus,s_pro_minus,s_ac_minus,s_hco3_minus,s_nh3,
S_gas_h2,S_gas_ch4,S_gas_co2]
#Extract steady state values
ss=[sol[i][end] for i in state]
#Define function to assign proper ordering to solution variables
function save_sol(sol)
    m,n=size(sol)
    osol = Array{Float64,2}(undef,m,n)
    osol[1,:]=sol[S_su]
    osol[2,:]=sol[S_aa]
    osol[3,:]=sol[S_fa]
    osol[4,:]=sol[S_va]
    osol[5,:]=sol[S_bu]
    osol[6,:]=sol[S_pro]
    osol[7,:]=sol[S_ac]
    osol[8,:]=sol[S_h2]
    osol[9,:]=sol[S_ch4]
    osol[10,:]=sol[S_IC]
    osol[11,:]=sol[S_IN]
    osol[12,:]=sol[S_I]
    osol[13,:]=sol[X_c]
    osol[14,:]=sol[X_ch]
    osol[15,:]=sol[X_pr]
    osol[16,:]=sol[X_li]
    osol[17,:]=sol[X_su]
    osol[18,:]=sol[X_aa]
    osol[19,:]=sol[X_fa]
    osol[20,:]=sol[X_c4]
    osol[21,:]=sol[X_pro]
    osol[22,:]=sol[X_ac]
    osol[23,:]=sol[X_h2]
    osol[24,:]=sol[X_I]
    osol[25,:]=sol[S_cat]
    osol[26,:]=sol[S_an]
    osol[27,:]=sol[S_H_plus]
    osol[28,:]=sol[S_gas_h2]
    osol[29,:]=sol[S_gas_ch4]
    osol[30,:]=sol[S_gas_co2]
    return osol
end
#Define function to plot all state variables of interest over time
function plot_states(sol,states,t_r)
    i=0
    for var in states
        i+=1;
        temp=plot(t_r,sol[var],xlabel="Time (days)",ylabel="Concentration (kgCOD·m–3)",title="$(var)",legend=false);
        savefig(temp,".\\DynamicStatePlots\\var$(i)$(var).png");
    end
end
#Run plotting routine
plot_dat = true #make true to plot data
plot_dat ? plot_states(sol,state,t_r) : nothing
#Write solution to CSV in local directory
save_dat = true #make true to save or false to not save
save_dat ? writedlm("MTK_ADM1sol_d.csv",save_sol(sol),",") : nothing
