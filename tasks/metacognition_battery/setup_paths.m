%% script setup paths
% MUST BE EXECUTE FROM HIGHEST /metacognition_battery

parent_dir = pwd;
gen_function_dir = fullfile(parent_dir, 'general_functions');
addpath(gen_function_dir);

proj_dir = fileparts(parent_dir);

if IsWin
    memdir = [parent_dir '\memory\'];
else
    memdir = [parent_dir '/memory/'];
end


if IsWin
    visiondir = [parent_dir '\vision_meta_dots\'];
else
    visiondir = [parent_dir '/vision_meta_dots/'];
end


if IsWin
    triviadir = [parent_dir '\trivia_task\taskcode\runtask\'];
else
    triviadir = [parent_dir '/trivia_task/taskcode/runtask/'];
end

