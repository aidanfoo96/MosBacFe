### Here, only using high quality genomes for further analysis
rule fegnie: 
    """ 
        Run fegnie on winning genomes
    """
    output: 
        fegenie_output = "../results/fegenie/FeGenie-summary-blasthits.csv",
    input: 
        assm = "../results/shovill/{sample}_shovill_assm/contigs.fa",
    params: 
        bin_dir = "../results/winning_genomes/",
    shell: 
        r"""
            FeGenie.py -bin_dir {params.bin_dir} -bin_ext fasta -out {output.fegenie_output}
         """

