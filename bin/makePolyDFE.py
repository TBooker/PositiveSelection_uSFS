def main(): 
	## This script makes a polyDFE initialistaion file that can be used to generate runs looking at the likelihood surface about Sa and pA
#Nes <- seq(0.1,1000,1000/50)
#pA <- seq(0.00001,0.01,0.01/50)
	Sa = [float(i)/0.2 for i in range(0, 2000, 1000/25)]
	pA = [float(i)/1000000 for i in range(1,1000,1000/50)]

	count = 0

	Sd = -2000
	shape = 0.3

	for s in Sa:
		for p in pA:
			count +=1
			model_id = count
			string =  map(str, [model_id, 1, 0.00, 1, 0.00, 0, 0.005, 0, 0.001, 0, 2, 1, Sd, 1, shape, 1, p, 1, s,0, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])
			print '\t'.join(string)

main()
