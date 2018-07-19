function EmmaG_function(n)
dir1 = '/home/emmagao96/data';
dir2 = '/sample #1 data file';
dir3_1 = '/CTRL';
dir3_2 = '/TTX';
dir4_psd = '/ROIs/psd_threshold_26_vf_zf/psd_threshold_26_vf_zf';
dir4_vglut = '/ROIs/vglut_threshold_26_vf_zf/vglut_threshold_26_vf_zf';

control_psd_file = [dir1 dir2 dir3_1 dir4_psd];
control_vglut_file = [dir1 dir2 dir3_1 dir4_vglut];
ttx_psd_file = [dir1 dir2 dir3_2 dir4_psd];

all_num = [];
for i = 1:n
    [number] = simulate_increase_size(control_psd_file,control_vglut_file,ttx_psd_file);
    all_num = [all_num number];
end

cd /home/emmagao96/data/results

%I dont know how to name the data file individaullt :(

save sim1.mat all_num
exit