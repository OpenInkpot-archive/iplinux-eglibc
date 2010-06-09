/* Initialize CPU feature data.
   This file is part of the GNU C Library.
   Copyright (C) 2008, 2009, 2010 Free Software Foundation, Inc.
   Contributed by Ulrich Drepper <drepper@redhat.com>.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#include <atomic.h>
#include <cpuid.h>
#include "init-arch.h"


struct cpu_features __cpu_features attribute_hidden;


static void
get_common_indeces (unsigned int *family, unsigned int *model)
{
  __cpuid (1, __cpu_features.cpuid[COMMON_CPUID_INDEX_1].eax,
	   __cpu_features.cpuid[COMMON_CPUID_INDEX_1].ebx,
	   __cpu_features.cpuid[COMMON_CPUID_INDEX_1].ecx,
	   __cpu_features.cpuid[COMMON_CPUID_INDEX_1].edx);

  unsigned int eax = __cpu_features.cpuid[COMMON_CPUID_INDEX_1].eax;
  *family = (eax >> 8) & 0x0f;
  *model = (eax >> 4) & 0x0f;
}


void
__init_cpu_features (void)
{
  unsigned int ebx;
  unsigned int ecx;
  unsigned int edx;
  unsigned int family = 0;
  unsigned int model = 0;
  enum cpu_features_kind kind;

  __cpuid (0, __cpu_features.max_cpuid, ebx, ecx, edx);

  /* This spells out "GenuineIntel".  */
  if (ebx == 0x756e6547 && ecx == 0x6c65746e && edx == 0x49656e69)
    {
      kind = arch_kind_intel;

      get_common_indeces (&family, &model);

      unsigned int eax = __cpu_features.cpuid[COMMON_CPUID_INDEX_1].eax;
      unsigned int extended_family = (eax >> 20) & 0xff;
      unsigned int extended_model = (eax >> 12) & 0xf0;
      if (__cpu_features.family == 0x0f)
	{
	  family += extended_family;
	  model += extended_model;
	}
      else if (__cpu_features.family == 0x06)
	model += extended_model;
    }
  /* This spells out "AuthenticAMD".  */
  else if (ebx == 0x68747541 && ecx == 0x444d4163 && edx == 0x69746e65)
    {
      kind = arch_kind_amd;

      get_common_indeces (&family, &model);
    }
  else
    kind = arch_kind_other;

  __cpu_features.family = family;
  __cpu_features.model = model;
  atomic_write_barrier ();
  __cpu_features.kind = kind;
}

#undef __get_cpu_features

const struct cpu_features *
__get_cpu_features (void)
{
  if (__cpu_features.kind == arch_kind_unknown)
    __init_cpu_features ();

  return &__cpu_features;
}