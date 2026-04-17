if [file exists work] {
    vdel -all
}

vlib work

vlog ac.v
vlog bc.v
vlog cla8.v
vlog cla_sub8.v
vlog counter.v
vlog booth_radix4.v
vlog restoring_division.v
vlog main.v
vlog main_tb.v


vsim -voptargs=+acc work.main_tb


add wave /main_tb/clock
add wave /main_tb/reset
add wave /main_tb/start
add wave /main_tb/op
add wave /main_tb/x
add wave /main_tb/y
add wave /main_tb/result
add wave /main_tb/ready

add wave /main_tb/uut/A
add wave /main_tb/uut/Q
add wave /main_tb/uut/AQ_div

run -all

wave zoom full