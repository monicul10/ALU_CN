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
vlog control_unit.v
vlog main.v
vlog main_tb.v


vsim -voptargs=+acc work.main_tb



add wave /main_tb/clk
add wave /main_tb/rst
add wave /main_tb/start
add wave /main_tb/op_sel
add wave /main_tb/x
add wave /main_tb/y
add wave /main_tb/result
add wave /main_tb/done



add wave /main_tb/uut/brain/state


add wave /main_tb/uut/multiplier/A
add wave /main_tb/uut/multiplier/Q
add wave /main_tb/uut/multiplier/M



add wave /main_tb/uut/divider/A
add wave /main_tb/uut/divider/Q
add wave /main_tb/uut/divider/M

run -all
wave zoom full