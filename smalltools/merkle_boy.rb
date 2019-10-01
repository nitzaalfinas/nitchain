# File ini dibuat hanya untuk keperluan riset sederhana cara membuat merkle root
# Setelah berhasil implementasi, file ini akan dihapus

merkles_arr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14"]

def jalan(merkles_arr)

    # cek juga jumlah merkle array terlebih dahulu, jika ganjil, maka tambahkan satu dibelakang
    # penggunaan ini cukup menarik pada tutorial ini https://stackoverflow.com/questions/18163475/ruby-check-if-even-number-float
    genap_ganjil = merkles_arr.count / 2.0
    puts genap_ganjil
    if genap_ganjil.round.even? == true
        merkles_arr.push(merkles_arr.last)
    end

    nu_arr = []
    urut = 0
    merkles_arr.each do |f|
        urut = urut + 1
        if urut % 2 == 0
            # puts ""
            # puts "--->"
            # puts urut
            # puts merkles_arr[urut-2]
            # puts merkles_arr[urut-1]

            nu_arr.push(merkles_arr[urut-2] + merkles_arr[urut-1])
        end
    end

    return nu_arr
end

zz = 0
loop do

    zz = zz + 1
    puts "======= zz #{zz}"

    merkles_arr = jalan(merkles_arr)

    puts "merkle_arr"
    puts merkles_arr.to_s
    puts merkles_arr.count

    if merkles_arr.count == 1
        break
    end
end

puts "=========ppppp"
puts merkles_arr
