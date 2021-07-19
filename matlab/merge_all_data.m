clearvars a b c metacognition_data_master
a = combine_mem_data();

b = combine_trivia_data();

c = combine_percept_data();

metacognition_data_master = vertcat(a,b);
metacognition_data_master = vertcat(metacognition_data_master,c);

writetable(metacognition_data_master, 'metacognition_data_master.csv')