#ifdef __cplusplus
extern "C" {
#endif

int main(int argc, char **argv)
{
extern void save_restore_check(int, char**);

extern char** trackerParseArgs(int argc, char** argv);
extern int trackerCountArgs(char** argv);
extern void scPreMain(int, char**);
extern int scsim_main(int, char**);

    save_restore_check(argc, argv);
    argv = trackerParseArgs(argc, argv);
    argc = trackerCountArgs(argv);
    scPreMain(argc, argv);
    return scsim_main(argc, argv);
}

#ifdef __cplusplus
}
#endif
