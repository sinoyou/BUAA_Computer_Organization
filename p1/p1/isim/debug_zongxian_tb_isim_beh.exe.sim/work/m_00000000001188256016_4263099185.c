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
static const char *ng0 = "H:/ISE_projects/p1_homework/debug_zongxian.v";
static unsigned int ng1[] = {236U, 0U};
static unsigned int ng2[] = {0U, 0U};



static void Initial_27_0(char *t0)
{
    char t3[8];
    char t6[8];
    char *t1;
    char *t2;
    char *t4;
    char *t5;
    char *t7;
    char *t8;
    unsigned int t9;
    unsigned int t10;
    unsigned int t11;
    unsigned int t12;
    unsigned int t13;
    unsigned int t14;
    char *t15;

LAB0:    xsi_set_current_line(27, ng0);

LAB2:    xsi_set_current_line(28, ng0);
    t1 = ((char*)((ng1)));
    t2 = (t0 + 1448);
    xsi_vlogvar_assign_value(t2, t1, 0, 0, 8);
    xsi_set_current_line(29, ng0);
    t1 = ((char*)((ng2)));
    t2 = (t0 + 1448);
    t4 = (t2 + 56U);
    t5 = *((char **)t4);
    memset(t6, 0, 8);
    t7 = (t6 + 4);
    t8 = (t5 + 4);
    t9 = *((unsigned int *)t5);
    t10 = (t9 >> 7);
    t11 = (t10 & 1);
    *((unsigned int *)t6) = t11;
    t12 = *((unsigned int *)t8);
    t13 = (t12 >> 7);
    t14 = (t13 & 1);
    *((unsigned int *)t7) = t14;
    xsi_vlogtype_concat(t3, 8, 4, 2U, t6, 1, t1, 3);
    t15 = (t0 + 1288);
    xsi_vlogvar_assign_value(t15, t3, 0, 0, 8);

LAB1:    return;
}


extern void work_m_00000000001188256016_4263099185_init()
{
	static char *pe[] = {(void *)Initial_27_0};
	xsi_register_didat("work_m_00000000001188256016_4263099185", "isim/debug_zongxian_tb_isim_beh.exe.sim/work/m_00000000001188256016_4263099185.didat");
	xsi_register_executes(pe);
}
