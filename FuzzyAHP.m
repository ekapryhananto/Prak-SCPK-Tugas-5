%pelayanan di toko komputer CakNanGanteng
namaPelayan = {'Eka' 'Pryhananto' 'Hanan'};
%kecepatan, sikap, kualitas
data = [ 5 6 6
         5 9 5
         8 8 9];
     
maksKecepatan = 10;
maksSikap = 10;
maksKualitas = 10;

data(:,1) = data(:,1)/maksKecepatan;
data(:,2) = data(:,2)/maksSikap;
data(:,3) = data(:,3)/maksKualitas;

relasiAntarKriteria = [ 1 2 2
                        0 1 4
                        0 0 1];

TFN = {[-100/3 0     100/3] [3/100 0     -3/100]
       [0      100/3 200/3] [3/200 3/100 0     ]
       [100/3  200/3 300/3] [3/300 3/200 3/100 ]
       [200/3  300/3 400/3] [3/400 3/300 3/200 ]};
   
indeksAcak = [0 0 0.58 0.9 1.12 1.24 1.32 1.41 1.45 1.49];

[op, jumlahKriteria] = size(relasiAntarKriteria);
[opp, lambda] = eig(relasiAntarKriteria);
maksLambda = max(max(lambda));
IndeksKonsistensi = (maksLambda - jumlahKriteria)/(jumlahKriteria - 1);
RasioKonsistensi = IndeksKonsistensi / indeksAcak(1,jumlahKriteria);

if RasioKonsistensi > 0.10
    str = 'Matriks yang dievaluasi tidak konsisten!';
    str = printf(str,RasioKonsistensi);
    disp(str);
end
if RasioKonsistensi < 0.10
    fuzzyRelasi = {};
    [jumlahData, jumlahKriteria] = size(relasiAntarKriteria);

    for i = 1:jumlahData
        for j =1+1:jumlahData
            relasiAntarKriteria(j,i) = 1 / relasiAntarKriteria(i,j);
        end
    end
    for i = 1:jumlahData
        for j = 1:jumlahKriteria
            kriteria = relasiAntarKriteria(i,j);
            if kriteria >= 1
                fuzzyRelasi{i,j} = TFN{kriteria ,1};
            else
                fuzzyRelasi{i,j} = TFN{round(kriteria^-1) ,2};
            end
        end
    end
    for i = 1:jumlahData
        barisRelasi = [fuzzyRelasi{i,:}];
        jumlahRelasiPerBaris{1,i} = sum (reshape(barisRelasi,3,[])');
    end

    RelasiPerData = [jumlahRelasiPerBaris{1,:}];
    jumlahRelasiPerKolom = sum(reshape(RelasiPerData,3,[])');

    for i = 1:jumlahData
        RelasiPerData = [jumlahRelasiPerBaris{1,i}];
        for j =1:3
            nilaiRelasiPerKolom = jumlahRelasiPerKolom(1,j);
            jumlahPerKolom(1,j) = (RelasiPerData(1,j)) * (1/nilaiRelasiPerKolom);
        end
        jumlahRelasiPerBaris{1,i} = jumlahPerKolom;
    end

    derajatKemungkinan = zeros(jumlahData*(jumlahData-1),3);
    idxBaris = 1;

    for i=1:jumlahData
        for j=1:jumlahData
            if i~=j
                derajatKemungkinan(idxBaris,[1 2]) = [i j];
                M1 = jumlahRelasiPerBaris{1,i};
                M2 = jumlahRelasiPerBaris{1,j};
                if M1(1,2) >= M2(1,2)
                    derajatKemungkinan(idxBaris,3) = 1;
                elseif M2(1,1) >= M1(1,3)
                    derajatKemungkinan(idxBaris,3) = 0;
                else
                    derajatKemungkinan(idxBaris,3) = (M2(1,1)- M1(1,3))/((M1(1,2)-M1(1,3))-(M2(1,2)-M2(1,1)));
                end
            idxBaris = idxBaris + 1;
            end
        end
    end

    bobotAntarKriteria = zeros(1,jumlahData);
    for i=1:jumlahData,
        bobotAntarKriteria(1,i) = min(derajatKemungkinan([find(derajatKemungkinan(:,1) == i)],[3]));
    end

    bobotAntarKriteria = bobotAntarKriteria/sum(bobotAntarKriteria);
        ahp = data * bobotAntarKriteria';
    disp('Perhitungan Kualitas Pelayanan di Toko CakNanGanteng')
    disp('Nama Pelayan, Skor Akhir, Rating')

        for i = 1:size(ahp, 1)
            if ahp(i) < 0.5
                status = 'Kurang';
            elseif ahp(i) < 0.65
                status = 'Cukup';
            elseif ahp(i) < 0.8
                status = 'Baik';
            else
                status = 'Sangat Baik';
            end
            disp([char(namaPelayan(i)), blanks(12 - cellfun('length',namaPelayan(i))), ', ', num2str(ahp(i)), blanks(10 - length(num2str(ahp(i)))), ', ', char(status)])
        end
end

        
        
        
