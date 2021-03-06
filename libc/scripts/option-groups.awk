# option-groups.awk --- generate option group header file
# Given input files containing makefile-style assignments to variables, 
# print out a header file that #defines an appropriate preprocessor
# symbol for each variable left set to 'y'.

BEGIN { FS="=" }

# Trim spaces.
{ gsub (/[[:blank:]]/, "") }

# Skip comments.
/^#/ { next }

# Process assignments.
NF == 2 {
    vars[$1] = $2
}

# Print final values.
END {
    print "/* This file is automatically generated by scripts/option-groups.awk"
    print "   in the EGLIBC source tree."
    print ""
    print "   It defines macros that indicate which EGLIBC option groups were"
    print "   configured in 'option-groups.config' when this C library was"
    print "   built.  For each option group named OPTION_foo, it #defines"
    print "   __OPTION_foo to be 1 if the group is enabled, or leaves that"
    print "   symbol undefined if the group is disabled.  */"
    print ""
    print "#ifndef __GNU_OPTION_GROUPS_H"
    print "#define __GNU_OPTION_GROUPS_H"
    print ""

    # Produce a sorted list of variable names.
    i=0
    for (var in vars)
        names[i++] = var
    n = asort (names)

    for (i = 1; i <= n; i++)
    {
        var = names[i]
        if (var ~ /^OPTION_/)
        {
            if (vars[var] == "y")
                print "#define __" var " 1"
            else if (vars[var] == "n")
                print "/* #undef __" var " */"
            # Ignore variables that don't have boolean values.
            # Ideally, this would be driven by the types given in
            # option-groups.def.
        }
    }

    print ""
    print "#endif /* __GNU_OPTION_GROUPS_H */"
}
