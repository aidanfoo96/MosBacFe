rule classify_GTDB_genomes: 
    """
        Classify assembled contigs against the GTDB-Tk classifier
    """
    output:
        "../results/GTDBTk_Classification/{sample}/",
    input: 
        "../results/megahit_assm/{sample}_assm/final.contigs.fa",
    params: 
        outdir = "../results/GTDBTk_Classification/{sample}/",
        indir = "../results/megahit_assm/{sample}_assm/",
        cpus = config["GTDBTkClassification"]["Threads"],
    shell: 
        r"""
            gtdbtk classify_wf --genome_dir {params.indir} \
            -x fa --out_dir {params.outdir} \
            --prefix gtdb_class --cpus {params.cpus}
         """
