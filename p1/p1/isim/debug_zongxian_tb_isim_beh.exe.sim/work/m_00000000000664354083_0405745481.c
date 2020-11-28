/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "value of a and b is %b %b";
static const char *ng1 = "H:/ISE_projects/p1_homework/debug_zongxian_tb.v";
static int ng2[] = {2, 0};
static unsigned int ng3[] = {1U, 0U};
static const char *ng4 = " value of b %b";
static const char *ng5 = "time = ";

void Monitor_44_1(char *);
void Monitor_44_1(char *);


static void Monitor_44_1_Func(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;

LAB0:    t1 = (t0 + 1448);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t4 = (t0 + 1608);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    xsi_vlogfile_write(1, 0, 3, ng0, 3, t0, (char)119, t3, 8, (char)119, t6, 8);

LAB1:    return;
}

static void Initial_39_0(char *t0)
{
    char t3[8];
    char t6[16];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    char *t9;
    char *t10;

LAB0:    t1 = (t0 + 2688U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(39, ng1);

LAB4:    xsi_set_current_line(43, ng1);
    t2 = (t0 + 2496);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(44, ng1);
    Monitor_44_1(t0);
    xsi_set_current_line(45, ng1);
    t2 = ((char*)((ng2)));
    memset(t3, 0, 8);
    xsi_vlog_signed_unary_minus(t3, 32, t2, 32);
    t4 = (t0 + 1448);
    xsi_vlogvar_assign_value(t4, t3, 0, 0, 8);
    xsi_set_current_line(46, ng1);
    t2 = ((char*)((ng3)));
    t4 = (t0 + 1608);
    xsi_vlogvar_assign_value(t4, t2, 0, 0, 8);
    xsi_set_current_line(47, ng1);
    t2 = (t0 + 1608);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    xsi_vlogfile_write(0, 0, 0, ng4, 2, t0, (char)119, t5, 8);
    t7 = xsi_vlog_time(t6, 1000.0000000000000, 1000.0000000000000);
    xsi_vlogfile_write(1, 0, 0, ng5, 2, t0, (char)118, t6, 64);
    xsi_set_current_line(49, ng1);
    t2 = (t0 + 1608);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    t7 = (t0 + 1448);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memset(t3, 0, 8);
    xsi_vlog_signed_less(t3, 8, t5, 8, t9, 8);
    t10 = (t0 + 1768);
    xsi_vlogvar_assign_value(t10, t3, 0, 0, 1);
    goto LAB1;

}

void Monitor_44_1(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 2744);
    t2 = (t0 + 3256);
    xsi_vlogfile_monitor((void *)Monitor_44_1_Func, t1, t2);

LAB1:    return;
}


extern void work_m_00000000000664354083_0405745481_init()
{
	static char *pe[] = {(void *)Initial_39_0,(void *)Monitor_44_1};
	xsi_register_didat("work_m_00000000000664354083_0405745481", "isim/debug_zongxian_tb_isim_beh.exe.sim/work/m_00000000000664354083_0405745481.didat");
	xsi_register_executes(pe);
}
