program PivotDeGauss;

const
  N = 3; //Taille de la matrice carrée

var
  A: array[1..N, 1..N] of real;
  B: array[1..N] of real;
  X: array[1..N] of real;
  i, j, k, ligneMax: integer;
  temp, factor: real;

begin
  // Saisie des coefficients de la matrice A et du vecteur B
  writeln('Entrez les coefficients de la matrice A :');
  for i := 1 to N do
    for j := 1 to N do
      read(A[i, j]);
      
  writeln('Entrez les coefficients du vecteur B :');
  for i := 1 to N do
    read(B[i]);

  // Algorithme du pivot de Gauss
  for i := 1 to N - 1 do
  begin
    // Recherche de la ligne pivot (avec le plus grand coefficient en valeur absolue)
    ligneMax := i;
    for j := i + 1 to N do
      if abs(A[j, i]) > abs(A[ligneMax, i]) then
        ligneMax := j;

    // Échange des lignes i et ligneMax de la matrice A
    if ligneMax <> i then
    begin
      for j := 1 to N do
      begin
        temp := A[i, j];
        A[i, j] := A[ligneMax, j];
        A[ligneMax, j] := temp;
      end;
      temp := B[i];
      B[i] := B[ligneMax];
      B[ligneMax] := temp;
    end;

    // Élimination des variables
    for j := i + 1 to N do
    begin
      factor := A[j, i] / A[i, i];
      for k := i to N do
        A[j, k] := A[j, k] - factor * A[i, k];
      B[j] := B[j] - factor * B[i];
    end;
  end;

  // Résolution du système
  for i := N downto 1 do
  begin
    X[i] := B[i];
    for j := i + 1 to N do
      X[i] := X[i] - A[i, j] * X[j];
    X[i] := X[i] / A[i, i];
  end;

  // Affichage de la solution
  writeln('La solution du système est :');
  for i := 1 to N do
    writeln('X[', i, '] = ', X[i]:0:2);
end.

