"""
function get_EU_LV_feeder_data()::Dict{String,Any}
    Gets the MATHEMATICAL data dictionary for the European Low Voltage Test Feeder.
    This function is just for tidiness, so the code doesn't have to be in the main scripts.
"""
get_EU_LV_feeder_data(;power_base::Float64=1.0) = get_feeder_data(1, 1; power_base = power_base)


function get_feeder_data(ntw::Int64, fdr::Int64; power_base::Float64=1.0)::Dict{String,Any}

    # the next few lines ``tell" the parser which subset and time step of the active power profiles to get
    season = "winter"
    time_step = 144
    elm = ["load"] 
    pfs = [0.95]   # constant power factor to obtain Q

    #this finds the repository where the data is stored and gets it in the `ENGINEERING` dictionary format
    data = _PMD.parse_file(_PMDSE.get_enwl_dss_path(ntw, fdr),data_model=_PMD.ENGINEERING)
    
    # this removes the transformer model. We are only considering the LV side so it does not matter, we have a slack bus instead.
    _PMDSE.rm_enwl_transformer!(data) 
    
    # this removes what we called ``superfluous" buses in the paper
    _PMDSE.reduce_enwl_lines_eng!(data) 

    # this is to convert all data in "per unit"
    data["settings"]["sbase_default"] = power_base

    # this adds the chosen profiles
    _PMDSE.insert_profiles!(data, season, elm, pfs, t = time_step)

    return _PMD.transform_data_model(data) # this transforms the network+profiles from an `ENGINEERING` to a `MATHEMATICAL` dict
end
