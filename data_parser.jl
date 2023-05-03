"""
function get_EU_LV_feeder_data()::Dict{String,Any}
    Gets the MATHEMATICAL data dictionary for the European Low Voltage Test Feeder.
    This function is just for tidiness, so the code doesn't have to be in the main scripts.
"""
get_EU_LV_feeder_data(;power_base::Float64=1.0) = get_feeder_data(1, 1; power_base = power_base)


function get_feeder_data(ntw::Int64, fdr::Int64; power_base::Float64=1.0)::Dict{String,Any}

    rm_transfo = true
    rd_lines = true
    season = "winter"
    time_step = 144
    elm = ["load"]
    pfs = [0.95]

    #"fixed" part below
    data = _PMD.parse_file(_PMDSE.get_enwl_dss_path(ntw, fdr),data_model=_PMD.ENGINEERING)
    if rm_transfo _PMDSE.rm_enwl_transformer!(data) end
    if rd_lines _PMDSE.reduce_enwl_lines_eng!(data) end
    data["settings"]["sbase_default"] = power_base

    _PMDSE.insert_profiles!(data, season, elm, pfs, t = time_step)

    return _PMD.transform_data_model(data)
end
