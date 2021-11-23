set dotenv-load := true

curr_dir := invocation_directory()
default_document_name := "document"
default_pretty_name := env_var_or_default("PRETTY_DOCUMENT_NAME", "") + `date +"%Y-%m-%d"`

_default:
	@just --list

# build, clean, & archive
package in=default_document_name: (build default_pretty_name in) clean (archive in default_pretty_name)

# build
build out=default_document_name in=default_document_name:
	@just altacv-xelatex {{in}}
	@just altacv-xelatex {{in}}
	@just biber {{in}}
	@just altacv-xelatex {{in}}

altacv-xelatex in:
	-xelatex -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape -output-driver="xdvipdfmx -z 0" "{{in}}.tex"

biber in:
	-biber "{{in}}"

_save in out outdir=curr_dir:
	mkdir -p {{outdir}}
	cp "{{in}}" "{{join(outdir, out)}}"

# archive
archive in out:
	mkdir -p archive
	cp "{{in}}.pdf" archive/"{{out}}.pdf"

# clean
clean:
	rm -f creationdate.* *.aux *.bbl *.bcf *.blg *.log *.out *.xml *.gz *.xmpi *.toc