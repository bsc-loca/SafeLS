# SafeLS

The Safe Lockstep (SafeLS for short) unit is a a RISC-V open source lockstep core based on Gaisler's NOEL-V core for the space domain, as well as its integration in the SELENE SoC that provides a complete microcontroller synthesizable on FPGA successfully assessed against space, automotive and railway safety-critical applications in the past.



## Reference
If you are using the SafeLS for an academic publication, please cite the following paper:


# Future work

* **The management of the error signal, which currently is not exported to software. We are currently in the process of making it a core interrupt, propagating it to the CLINT, and capturing it at the software level whenever raised. We do not foresee difficulties in this task since we have already achieved such goal for the interrupts raised by the SafeSU.

* **The strong timing constraints imposed by the AHB protocol implementation, which does not allow for delaying AHB outputs of the cores. Hence, we cannot stagger those outputs and compare them prior to delivering them to the AHB interface since doing so leads to a platform crash. Instead, signals from the main core are delivered immediately to preserve original timings and staggering is used for comparison and error detection. However, upon an error detection, the potentially erroneous output of the master core has already been delivered for a few cycles (i.e., as many as the number of cycles used for staggering). This requires either means to stop the propagation of such signal or, instead, modifying the AHB interface module of the core so that some staggering is allowed and those signals can be delivered to the AHB interface only after successful comparison. We are currently investigating the viability of the latter since it would allow preserving the canonical implementation of DCLS.


