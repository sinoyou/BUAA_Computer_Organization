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
static int ng2[] = {0, 0};
static unsigned int ng3[] = {9U, 0U};
static unsigned int ng4[] = {1U, 0U};
static const char *ng5 = " value of b %b";
static const char *ng6 = "time = ";

void Monitor_47_1(char *);
void Monitor_47_1(char *);


static void Monitor_47_1_Func(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;

LAB0:    t1 = (t0 + 1584);
    t2 = (t1 + 56U);
    t3 = *((char **)t2);
    t4 = (t0 + 2064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    xsi_vlogfile_write(1, 0, 3, ng0, 3, t0, (char)119, t3, 8, (char)118, t6, 1);

LAB1:    return;
}

static void Initial_41_0(char *t0)
{
    char t5[16];
    char t9[8];
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t6;
    char *t7;
    char *t8;
    char *t10;

LAB0:    t1 = (t0 + 2984U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(41, ng1);

LAB4:    xsi_set_current_line(45, ng1);
    t2 = (t0 + 2792);
    xsi_process_wait(t2, 100000LL);
    *((char **)t1) = &&LAB5;

LAB1:    return;
LAB5:    xsi_set_current_line(46, ng1);
    t2 = ((char*)((ng2)));
    t3 = (t0 + 2064);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 1);
    xsi_set_current_line(47, ng1);
    Monitor_47_1(t0);
    xsi_set_current_line(48, ng1);
    t2 = ((char*)((ng3)));
    t3 = (t0 + 1584);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(49, ng1);
    t2 = ((char*)((ng4)));
    t3 = (t0 + 1744);
    xsi_vlogvar_assign_value(t3, t2, 0, 0, 8);
    xsi_set_current_line(50, ng1);
    t2 = (t0 + 1744);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    xsi_vlogfile_write(0, 0, 0, ng5, 2, t0, (char)119, t4, 8);
    t6 = xsi_vlog_time(t5, 1000.0000000000000, 1000.0000000000000);
    xsi_vlogfile_write(1, 0, 0, ng6, 2, t0, (char)118, t5, 64);
    xsi_set_current_line(52, ng1);
    t2 = (t0 + 1744);
    t3 = (t2 + 56U);
    t4 = *((char **)t3);
    t6 = (t0 + 1584);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memset(t9, 0, 8);
    xsi_vlog_signed_less(t9, 8, t4, 8, t8, 8);
    t10 = (t0 + 1904);
    xsi_vlogvar_assign_value(t10, t9, 0, 0, 1);
    goto LAB1;

}

static void Always_56_2(char *t0)
{
    char t3[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t6;
    char *t7;
    unsigned int t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    char *t15;
    unsigned int t16;
    unsigned int t17;
    unsigned int t18;
    unsigned int t19;
    unsigned int t20;
    unsigned int t21;
    unsigned int t22;
    unsigned int t23;
    char *t24;

LAB0:    t1 = (t0 + 3232U);
    t2 = *((char **)t1);
    if (t2 == 0)
        goto LAB2;

LAB3:    goto *t2;

LAB2:    xsi_set_current_line(56, ng1);
    t2 = (t0 + 3040);
    xsi_process_wait(t2, 10000LL);
    *((char **)t1) = &&LAB4;

LAB1:    return;
LAB4:    xsi_set_current_line(56, ng1);
    t4 = (t0 + 2064);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memset(t3, 0, 8);
    t7 = (t6 + 4);
    t8 = *((unsigned int *)t7);
    t9 = (~(t8));
    t10 = *((unsigned int *)t6);
    t11 = (t10 & t9);
    t12 = (t11 & 1U);
    if (t12 != 0)
        goto LAB8;

LAB6:    if (*((unsigned int *)t7) == 0)
        goto LAB5;

LAB7:    t13 = (t3 + 4);
    *((unsigned int *)t3) = 1;
    *((unsigned int *)t13) = 1;

LAB8:    t14 = (t3 + 4);
    t15 = (t6 + 4);
    t16 = *((unsigned int *)t6);
    t17 = (~(t16));
    *((unsigned int *)t3) = t17;
    *((unsigned int *)t14) = 0;
    if (*((unsigned int *)t15) != 0)
        goto LAB10;

LAB9:    t22 = *((unsigned int *)t3);
    *((unsigned int *)t3) = (t22 & 1U);
    t23 = *((unsigned int *)t14);
    *((unsigned int *)t14) = (t23 & 1U);
    t24 = (t0 + 2064);
    xsi_vlogvar_assign_value(t24, t3, 0, 0, 1);
    goto LAB2;

LAB5:    *((unsigned int *)t3) = 1;
    goto LAB8;

LAB10:    t18 = *((unsigned int *)t3);
    t19 = *((unsigned int *)t15);
    *((unsigned int *)t3) = (t18 | t19);
    t20 = *((unsigned int *)t14);
    t21 = *((unsigned int *)t15);
    *((unsigned int *)t14) = (t20 | t21);
    goto LAB9;

}

void Monitor_47_1(char *t0)
{
    char *t1;
    char *t2;

LAB0:    t1 = (t0 + 3288);
    t2 = (t0 + 3800);
    xsi_vlogfile_monitor((void *)Monitor_47_1_Func, t1, t2);

LAB1:    return;
}


extern void work_m_00000000004204417938_0405745481_init()
{
	static char *pe[] = {(void *)Initial_41_0,(void *)Always_56_2,(void *)Monitor_47_1};
	xsi_register_didat("work_m_00000000004204417938_0405745481", "isim/debug_zongxian_tb_isim_beh.exe.sim/work/m_00000000004204417938_0405745481.didat");
	xsi_register_executes(pe);
}
