


st1 = results.Corrects(results.WhichCondition==1)

st2 = results.Corrects(results.WhichCondition==2)

acc1 = mean(st1)

acc2=mean(st2)

st1(1:40) = []
st2(1:40) = []

acc1 = mean(st1)

acc2=mean(st2)

