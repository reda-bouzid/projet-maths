program Decomposition_LU;

const
	N = 12; //Dimension de la matrice

type
	Matrice = array[1..N, 1..N] of real;
	Vecteur = array[1..N] of real;

procedure creerIdentite(var M: Matrice; n : Integer);
var
	i, j: Integer;
begin
	for i := 1 to n do
	begin
		for j := 1 to n do if i = j then M[i, j] := 1 else M[i, j] := 0;
	end;
end;

procedure creerHilbert(var M: Matrice; n : Integer);
var
	i, j: Integer;
begin
	for i := 1 to n do
	begin
		for j := 1 to n do
		begin
			M[i, j] := 1/(i+j-1);
		end;
	end;
end;


procedure DecompositionLU(var A, L, U: Matrice; n : Integer);
var
	j, k, i: Integer;
	facteur: real;
begin
	U := A;
	creerIdentite(L, N);

	for k := 1 to N - 1 do
		for i := k + 1 to N do
		begin
			// Calcul du multiplicateur
			facteur := U[i, k] / U[k, k];

			// Mise à jour de la matrice U
			for j := k to N do
				U[i, j] := U[i, j] - facteur * U[k, j];

			// Stockage du multiplicateur dans la matrice L
			L[i, k] := facteur;
		end;
end;

procedure ResoudreSystemeLineaire(var L, U: Matrice; var B, Y, X: Vecteur);
var
  i, j: Integer;
  Somme: real;
begin
  // Résoudre Ly = B
  for i := 1 to N do
  begin
    Somme := 0;
    for j := 1 to i - 1 do
      Somme := Somme + L[i, j] * Y[j];
    Y[i] := (B[i] - Somme) / L[i, i];
  end;

  // Résoudre Ux = y
  for i := N downto 1 do
  begin
    Somme := 0;
    for j := i + 1 to N do
      Somme := Somme + U[i, j] * X[j];
    X[i] := (Y[i] - Somme) / U[i, i];
  end;
end;

procedure ecrireMatricesSortie(const A, L, U: Matrice; X, B : Vecteur);
var FichierTest : TextFile;
	i, j : Integer;
begin
	//Ouverture du fichier en écriture
	assign(FichierTest, 'sortie.txt');
	Rewrite(FichierTest);
	
	writeln(FichierTest, 'Matrice');
	//Ecriture de la matrice dans le fichier
	for i := 1 to N do
	begin
		for j := 1 to N do
			write(FichierTest, A[i, j]:0:20, ' ');  //Affichage de deux décimales
		writeln(FichierTest);
	end;
	writeln(FichierTest);


	writeln(FichierTest, 'Lower');
	//Ecriture de la matrice dans le fichier
	for i := 1 to N do
	begin
		for j := 1 to N do
			write(FichierTest, L[i, j]:0:20, ' ');  //Affichage de deux décimales
		writeln(FichierTest);
	end;
	writeln(FichierTest);
  
	writeln(FichierTest, 'Upper');
	// Écrire la matrice dans le fichier
	for i := 1 to N do
	begin
		for j := 1 to N do
			write(FichierTest, U[i, j]:0:20, ' ');  //Affichage de deux décimales
		writeln(FichierTest);
	end;
	writeln(FichierTest);
	
	writeln(FichierTest, 'B');
	// Écrire la matrice dans le fichier
	for i := 1 to N do
	begin
		write(FichierTest, B[i]:0:20, ' ');  //Affichage de deux décimales
		writeln(FichierTest);
	end;
	writeln(FichierTest);
	

	writeln(FichierTest, 'X');	
	// Écrire la matrice dans le fichier
	for i := 1 to N do
	begin
		write(FichierTest, X[i]:0:20, ' ');  //Affichage de deux décimales
		writeln(FichierTest);
	end;
	
	// Fermeture du fichier
	close(FichierTest);
end;

function vecteurHilbert(ligne, n : integer): real;
var
	i: Integer;
	somme : real;
begin
	somme := 0;
	for i := 1 to n do
	begin
		somme := somme + 1/(i+ligne-1);
	end;
	vecteurHilbert := somme;
end;

procedure creerVecteurHilbert(var B : Vecteur);
var
	i: Integer;
begin
	for i := 1 to n do
	begin
		B[i] := vecteurHilbert(i,N);
	end;
end;


var
	A, L, U: Matrice;
	B, X, Y: Vecteur;
	
begin
	creerHilbert(A, N);
	creerVecteurHilbert(B);
	DecompositionLU(A, L, U, N);
	ResoudreSystemeLineaire(L, U, B, Y, X);
	
	ecrireMatricesSortie(A, L, U, X, B);
end.
