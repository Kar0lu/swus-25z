#!/usr/bin/env sh

tc qdisc del dev $1 root 2>/dev/null || true
tc qdisc del dev $1 clsact 2>/dev/null || true
tc filter del dev $1

tc qdisc add dev $1 clsact

tc qdisc add dev $1 root handle 1: htb default 30
tc class add dev $1 parent 1: classid 1:1 htb rate 1mbit
tc class add dev $1 parent 1:1 classid 1:10 htb rate 1kbit ceil 1kbit
tc class add dev $1 parent 1:1 classid 1:20 htb rate 9kbit ceil 9kbit
tc class add dev $1 parent 1:1 classid 1:30 htb rate 20mbit ceil 20mbit

tc filter add dev $1 ingress bpf da obj classifier.o sec tc
tc filter add dev $1 egress bpf da obj classifier.o sec tc

tc filter add dev $1 parent 1: basic match 'meta(tc_index eq 0x10)' flowid 1:10
tc filter add dev $1 parent 1: basic match 'meta(tc_index eq 0x20)' flowid 1:20
tc filter add dev $1 parent 1: basic match 'meta(tc_index eq 0x30)' flowid 1:30

# tc qdisc add dev $1 parent 1:10 handle 10: sfq perturb 10
# tc qdisc add dev $1 parent 1:20 handle 20: sfq perturb 10
# tc qdisc add dev $1 parent 1:30 handle 30: sfq perturb 10

tc -s class show dev $1
tc -s qdisc show dev $1
tc -s filter show dev $1
tc -s filter show dev $1 ingress

bpftool map show

# Tu trzeba sprawdzić ID mapy po załadowaniu filtra do eBPF, więc nie robię tego automatycznie, mogę co najwyżej drugi skryt dorobić

# To wedle moich najlepszych chęci powinno przypisywać ruch TCP do klasy 1:10
# bpftool map update id <ID_MAPY> key hex 06 00 00 00 value hex 01 00 00 00 01 00 00 00 10 00 00 00

# Potem można zweryfikować co jest w mapie tym
# bpftool map dump id