### Here, only using high quality genomes for further analysis

def get_good_genome_input(wildcards):
    """
        Function to return 'good' genomes
    """
    unit2 = GoodGenomes_table.loc[wildcards.GoodGenome]
    return expand(
        "../results/spades/{GoodGenome}_spades_assm/{GoodGenome}.fasta".format(
            GoodGenome = unit2["sample"],
        )
    )


rule copy_winning_genomes: 
    """
        Move winning genomes from CheckM directory using 
        names from GoodGenomes 
    """
    output: 
       contigs =  "../results/winning_genomes/{GoodGenome}.fasta",
    input: 
        get_good_genome_input,
    shell: 
        "cp {input} {output.contigs}"
    

rule fegnie: 
    """ 
        Run fegnie on winning genomes
    """
    output: 
        fegenie_output = "../results/fegenie/FeGenie-summary-blasthits.csv",
    input: 
        contigs =  expand("../results/winning_genomes/{GoodGenome}.fasta", GoodGenome = GoodGenomes),
    params: 
        bin_dir = "../results/winning_genomes/",
    shell: 
        r"""
            FeGenie.py -bin_dir {params.bin_dir} -bin_ext fasta -out {output.fegenie_output}
         """

