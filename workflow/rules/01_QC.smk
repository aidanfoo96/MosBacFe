#-------------------------------------------------------------------#
def get_input(wildcards): 
    """
        Function to acquire bacterial reads from resources directory
    """
    fastqID = pd.read_csv(config["input_config"]["samples_table"], sep = "\t", index_col = "sampleID")
    
    final = fastqID.loc[wildcards.sample, ["fastq1Path", "fastq2Path"]].dropna() 

    return [f"{final.fastq1Path}", f"{final.fastq2Path}"]


#-------------------------------------------------------------------#
rule do_fastqc: 
    """
        Perform FASTQC on paired fastq files
    """
    output: 
        html = "../results/qc/fastqc/{sample}_{num}.html", 
        zip = "../results/qc/fastqc/{sample}_{num}_fastqc.zip"
    input: 
        get_input
    log: 
        "logs/fastqc/{sample}_{num}.log", 
    threads: 
        5
    params: 
        outdir="--outdir ../results/qc/fastqc",
    wrapper: 
        "v0.80.1/bio/fastqc"


rule trim_sequences: 
    """
        Trim sequences fastq files 
        Trimming parameters specified in contig file under "CutadaptParams" 
    """
    output: 
        fastq1 = "../results/qc/trimmed_fastq/{sample}_trimmed_1.fastq",
        fastq2 = "../results/qc/trimmed_fastq/{sample}_trimmed_2.fastq", 
        qc = "trimmed/{sample}.qc.txt",
    input:
        get_input
    params: 
        extra = config["QC_Reads"]["CutadaptParams"],
    log: 
        "logs/cutadapt/{sample}.log", 
    threads: 
        20
    wrapper:
        "0.77.0/bio/cutadapt/pe"