1032/12


a=0!86;
b=3.38;
c=3.18;
(
for(0,85, {
	|i|
	var step;
	step = (c-b)/86;
	a[i]=b+(step*i);
})
)
a.postln

a=