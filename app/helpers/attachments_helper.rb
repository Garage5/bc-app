module AttachmentsHelper

def icon_url_for_filetype(filename)
  icons = [
    'ai', 
    'bmp', 
    'css', 
    'doc', 
    'gif', 
    'html', 
    'jpeg', 
    'jpg', 
    'mov', 
    'mp3', 
    'pdf', 
    'php', 
    'psd', 
    'rar', 
    'wmv', 
    'xml', 
    'zip'
  ]
  extension = filename.split('.').last
  icon = icons.include?(extension) ? "#{extension.capitalize}.png" : "Default.png" 
  return "/images/attach_types/#{icon}"
end

end
