# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.triggers import RisingEdge

# uio_out[0] is ADC CS
# uio_out[3] is ADC CLK
# uio_in[1] is ADC Data

# ui_in[7:0] is the comparison value
# ui_out[0] is green LED
# ui_out[1] is red LED

# rst_n is inverted, so set low to begin reset

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    clock = Clock(dut.clk, 125, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    dut.ui_in.value = 100
    await ClockCycles(dut.clk, 10)

    assert dut.uo_out.value == 0
