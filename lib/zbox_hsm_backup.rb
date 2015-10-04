require 'zbox_hsm_backup/version'
require 'pp'

# Docs
module ZboxHsmBackup
  require 'mail'

  ZMVOLUME_CMD = '/opt/zimbra/bin/zmvolume'
  EXTRACT_HSM_NAME = 'grep -i hsm | awk -F"/" \'{print $4}\''
  SOURCE_PATH = '/opt/zimbra'
  BACKUP_PATH = '/backup'
  RSYNC_CMD = '/usr/bin/rsync'

  class << self
    def start(options = {})
      status = options[:status] || 'online'
      hsms = status == 'online' ? [online_hsm] : offline_hsms
      puts "Ejecutando backups para #{hsms.join(', ')}"
      Parallel.each(hsms) do |hsm|
        backup(hsm, options)
      end
    end

    def backup(hsm, options)
      sync_paths = "#{SOURCE_PATH}/#{hsm}/ #{BACKUP_PATH}/#{hsm}/"
      system("mount -o remount,rw #{BACKUP_PATH}/#{hsm}/")
      result = `/usr/bin/rsync -av --delete #{sync_paths}`
      system("mount -o remount,ro #{BACKUP_PATH}/#{hsm}/")
      send_report(options[:to], options[:mta], hsm, result)
    end

    def send_report(to, server, hsm, result)
      Mail.defaults do
        delivery_method :smtp, address: server, port: 25
      end
      mail = Mail.new do
        from 'admin@zboxapp.com'
        to to
        subject "[HSM-BACKUP: #{hsm}] Resultado para #{`hostname`.chomp}"
        body result
      end
      mail.deliver
    end

    def online_hsm
      `#{ZMVOLUME_CMD} -dc | #{EXTRACT_HSM_NAME}`.gsub(/\n/, '')
    end

    def offline_hsms
      all_hsm = `#{ZMVOLUME_CMD} -l | grep path | #{EXTRACT_HSM_NAME}`.split(/\n/)
      all_hsm.delete(online_hsm)
      all_hsm
    end

  end
end
