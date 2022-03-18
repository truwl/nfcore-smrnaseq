version 1.0

workflow smrnaseq {
	input{
		File samplesheet
		String protocol = "illumina"
		String outdir = "./results"
		String? email
		String? genome
		String? mirtrace_species
		File? fasta
		String? mirna_gtf
		String mature = "ftp://mirbase.org/pub/mirbase/CURRENT/mature.fa.gz"
		String hairpin = "ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz"
		String? bt_index
		String? references_parsed
		Boolean save_reference = true
		String igenomes_base = "s3://ngi-igenomes/igenomes"
		Boolean? igenomes_ignore
		String? bt_indices
		Int min_length = 17
		Int? clip_r1
		Int? three_prime_clip_r1
		String three_prime_adapter = "TGGAATTCTCGGGTGCCAAGG"
		String mirtrace_protocol = "illumina"
		Int trim_galore_max_length = 40
		Boolean? skip_qc
		Boolean? skip_fastqc
		Boolean? skip_mirdeep
		Boolean? skip_multiqc
		Boolean? help
		String publish_dir_mode = "copy"
		Boolean validate_params = true
		String? seq_center
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean? show_hidden_params
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}

	call make_uuid as mkuuid {}
	call touch_uuid as thuuid {
		input:
			outputbucket = mkuuid.uuid
	}
	call run_nfcoretask as nfcoretask {
		input:
			samplesheet = samplesheet,
			protocol = protocol,
			outdir = outdir,
			email = email,
			genome = genome,
			mirtrace_species = mirtrace_species,
			fasta = fasta,
			mirna_gtf = mirna_gtf,
			mature = mature,
			hairpin = hairpin,
			bt_index = bt_index,
			references_parsed = references_parsed,
			save_reference = save_reference,
			igenomes_base = igenomes_base,
			igenomes_ignore = igenomes_ignore,
			bt_indices = bt_indices,
			min_length = min_length,
			clip_r1 = clip_r1,
			three_prime_clip_r1 = three_prime_clip_r1,
			three_prime_adapter = three_prime_adapter,
			mirtrace_protocol = mirtrace_protocol,
			trim_galore_max_length = trim_galore_max_length,
			skip_qc = skip_qc,
			skip_fastqc = skip_fastqc,
			skip_mirdeep = skip_mirdeep,
			skip_multiqc = skip_multiqc,
			help = help,
			publish_dir_mode = publish_dir_mode,
			validate_params = validate_params,
			seq_center = seq_center,
			email_on_fail = email_on_fail,
			plaintext_email = plaintext_email,
			max_multiqc_email_size = max_multiqc_email_size,
			monochrome_logs = monochrome_logs,
			multiqc_config = multiqc_config,
			tracedir = tracedir,
			show_hidden_params = show_hidden_params,
			max_cpus = max_cpus,
			max_memory = max_memory,
			max_time = max_time,
			custom_config_version = custom_config_version,
			custom_config_base = custom_config_base,
			hostnames = hostnames,
			config_profile_name = config_profile_name,
			config_profile_description = config_profile_description,
			config_profile_contact = config_profile_contact,
			config_profile_url = config_profile_url,
			outputbucket = thuuid.touchedbucket
            }
		output {
			Array[File] results = nfcoretask.results
		}
	}
task make_uuid {
	meta {
		volatile: true
}

command <<<
        python <<CODE
        import uuid
        print("gs://truwl-internal-inputs/nf-smrnaseq/{}".format(str(uuid.uuid4())))
        CODE
>>>

  output {
    String uuid = read_string(stdout())
  }
  
  runtime {
    docker: "python:3.8.12-buster"
  }
}

task touch_uuid {
    input {
        String outputbucket
    }

    command <<<
        echo "sentinel" > sentinelfile
        gsutil cp sentinelfile ~{outputbucket}/sentinelfile
    >>>

    output {
        String touchedbucket = outputbucket
    }

    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task fetch_results {
    input {
        String outputbucket
        File execution_trace
    }
    command <<<
        cat ~{execution_trace}
        echo ~{outputbucket}
        mkdir -p ./resultsdir
        gsutil cp -R ~{outputbucket} ./resultsdir
    >>>
    output {
        Array[File] results = glob("resultsdir/*")
    }
    runtime {
        docker: "google/cloud-sdk:latest"
    }
}

task run_nfcoretask {
    input {
        String outputbucket
		File samplesheet
		String protocol = "illumina"
		String outdir = "./results"
		String? email
		String? genome
		String? mirtrace_species
		File? fasta
		String? mirna_gtf
		String mature = "ftp://mirbase.org/pub/mirbase/CURRENT/mature.fa.gz"
		String hairpin = "ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz"
		String? bt_index
		String? references_parsed
		Boolean save_reference = true
		String igenomes_base = "s3://ngi-igenomes/igenomes"
		Boolean? igenomes_ignore
		String? bt_indices
		Int min_length = 17
		Int? clip_r1
		Int? three_prime_clip_r1
		String three_prime_adapter = "TGGAATTCTCGGGTGCCAAGG"
		String mirtrace_protocol = "illumina"
		Int trim_galore_max_length = 40
		Boolean? skip_qc
		Boolean? skip_fastqc
		Boolean? skip_mirdeep
		Boolean? skip_multiqc
		Boolean? help
		String publish_dir_mode = "copy"
		Boolean validate_params = true
		String? seq_center
		String? email_on_fail
		Boolean? plaintext_email
		String max_multiqc_email_size = "25.MB"
		Boolean? monochrome_logs
		String? multiqc_config
		String tracedir = "./results/pipeline_info"
		Boolean? show_hidden_params
		Int max_cpus = 16
		String max_memory = "128.GB"
		String max_time = "240.h"
		String custom_config_version = "master"
		String custom_config_base = "https://raw.githubusercontent.com/nf-core/configs/master"
		String? hostnames
		String? config_profile_name
		String? config_profile_description
		String? config_profile_contact
		String? config_profile_url

	}
	command <<<
		export NXF_VER=21.10.5
		export NXF_MODE=google
		echo ~{outputbucket}
		/nextflow -c /truwl.nf.config run /smrnaseq-1.1.0  -profile truwl,nfcore-smrnaseq  --input ~{samplesheet} 	~{"--samplesheet '" + samplesheet + "'"}	~{"--protocol '" + protocol + "'"}	~{"--outdir '" + outdir + "'"}	~{"--email '" + email + "'"}	~{"--genome '" + genome + "'"}	~{"--mirtrace_species '" + mirtrace_species + "'"}	~{"--fasta '" + fasta + "'"}	~{"--mirna_gtf '" + mirna_gtf + "'"}	~{"--mature '" + mature + "'"}	~{"--hairpin '" + hairpin + "'"}	~{"--bt_index '" + bt_index + "'"}	~{"--references_parsed '" + references_parsed + "'"}	~{true="--save_reference  " false="" save_reference}	~{"--igenomes_base '" + igenomes_base + "'"}	~{true="--igenomes_ignore  " false="" igenomes_ignore}	~{"--bt_indices '" + bt_indices + "'"}	~{"--min_length " + min_length}	~{"--clip_r1 " + clip_r1}	~{"--three_prime_clip_r1 " + three_prime_clip_r1}	~{"--three_prime_adapter '" + three_prime_adapter + "'"}	~{"--mirtrace_protocol '" + mirtrace_protocol + "'"}	~{"--trim_galore_max_length " + trim_galore_max_length}	~{true="--skip_qc  " false="" skip_qc}	~{true="--skip_fastqc  " false="" skip_fastqc}	~{true="--skip_mirdeep  " false="" skip_mirdeep}	~{true="--skip_multiqc  " false="" skip_multiqc}	~{true="--help  " false="" help}	~{"--publish_dir_mode '" + publish_dir_mode + "'"}	~{true="--validate_params  " false="" validate_params}	~{"--seq_center '" + seq_center + "'"}	~{"--email_on_fail '" + email_on_fail + "'"}	~{true="--plaintext_email  " false="" plaintext_email}	~{"--max_multiqc_email_size '" + max_multiqc_email_size + "'"}	~{true="--monochrome_logs  " false="" monochrome_logs}	~{"--multiqc_config '" + multiqc_config + "'"}	~{"--tracedir '" + tracedir + "'"}	~{true="--show_hidden_params  " false="" show_hidden_params}	~{"--max_cpus " + max_cpus}	~{"--max_memory '" + max_memory + "'"}	~{"--max_time '" + max_time + "'"}	~{"--custom_config_version '" + custom_config_version + "'"}	~{"--custom_config_base '" + custom_config_base + "'"}	~{"--hostnames '" + hostnames + "'"}	~{"--config_profile_name '" + config_profile_name + "'"}	~{"--config_profile_description '" + config_profile_description + "'"}	~{"--config_profile_contact '" + config_profile_contact + "'"}	~{"--config_profile_url '" + config_profile_url + "'"}	-w ~{outputbucket}
	>>>
        
    output {
        File execution_trace = "pipeline_execution_trace.txt"
        Array[File] results = glob("results/*/*html")
    }
    runtime {
        docker: "truwl/nfcore-smrnaseq:1.1.0_0.1.0"
        memory: "2 GB"
        cpu: 1
    }
}
    