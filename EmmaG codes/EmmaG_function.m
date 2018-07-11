function EmmaG_function
all_num = [];
for i = 1:20
    [number] = simulate_increase_num(file_folder);
    all_num = [all_num number];
end
save result.mat all_num
exit