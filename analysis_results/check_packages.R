
            # Check and install required packages
            required_packages <- c("BiocManager", "MsQuality", "Spectra", "MsExperiment")
            
            for (pkg in required_packages) {
                if (!requireNamespace(pkg, quietly = TRUE)) {
                    if (pkg == "BiocManager") {
                        install.packages("BiocManager", repos = "https://cran.r-project.org")
                    } else {
                        BiocManager::install(pkg)
                    }
                }
            }
            
            # Test loading
            library(MsQuality)
            library(Spectra)
            cat("SUCCESS: All packages loaded\n")
            