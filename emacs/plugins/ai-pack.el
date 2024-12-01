(require 'gptel)
(setq
 gptel-model 'mistral:latest
 gptel-backend (gptel-make-ollama "Ollama"
                 :host "localhost:11434"
                 :stream t
                 :models '(mistral:latest)))

(provide 'ai-pack)
