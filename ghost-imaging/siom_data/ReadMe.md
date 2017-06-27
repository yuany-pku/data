Spectral GISC Camera Data Instruction

	y=Ax (single precision)

Measurement Matrix A 

folder ../A/

	A is the combination of RO_5x0nm.mat.
	A=[R0_510nm,R0_520nm,R0_530nm,R0_540nm,R0_550nm, ...
  	R0_560nm,R0_570nm,R0_580nm,R0_590nm];
	size R0_5x0nm: 176400 * 19600
	size A: 176400 * 176400; CR: 100%

Observed Signal y(mario or aloe)

folder ../y/

	size y: 176400 * 1

Optimization Variable 

x(vector)/X(cube matrix)

	size x: 176400 * 1, size X: 140 * 140 * 9
	
../references/ folder contains two reference images aloe.png and mario.png
