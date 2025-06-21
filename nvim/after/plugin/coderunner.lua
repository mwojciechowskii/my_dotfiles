vim.keymap.set('n', '<leader>r', ':RunCode<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rft', ':RunFile tab<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>crf', ':CRFiletype<CR>', { noremap = true, silent = false })
vim.keymap.set('n', '<leader>crp', ':CRProjects<CR>', { noremap = true, silent = false })

--valgrind
vim.keymap.set('n', '<leader>vr', function()
  local ft = vim.bo.filetype
  if ft == 'c' then
    require('code_runner.commands').run_code('c_valgrind')
  elseif ft == 'cpp' then
    require('code_runner.commands').run_code('cpp_valgrind')
  else
    print("Valgrind runner only supports C/C++")
  end
end, { noremap = true, silent = false, desc = "Run with Valgrind" })

require('code_runner').setup({
  filetype = {
    java = {
      "cd $dir &&",
      "javac $fileName &&",
      "java $fileNameWithoutExt"
    },
    python = "python3 -u",
    typescript = "deno run",
    rust = {
      "cd $dir &&",
      "rustc $fileName &&",
      "$dir/$fileNameWithoutExt"
    },
    c = function(...)
      local c_base = {
        "cd $dir &&",
        "gcc -Wall $fileName -o",
        "/tmp/$fileNameWithoutExt",
      }
      local c_exec = {
        "&& /tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      }
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        c_base[4] = input
        vim.print(vim.tbl_extend("force", c_base, c_exec))
        require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
      end)
    end,
    cpp = function(...)
      local cpp_base = {
        "cd $dir &&",
        "g++ -Wall $fileName -o",
        "/tmp/$fileNameWithoutExt",
      }
      local cpp_exec = {
        "&& /tmp/$fileNameWithoutExt &&",
        "rm /tmp/$fileNameWithoutExt",
      }
      vim.ui.input({ prompt = "Add more args:" }, function(input)
        cpp_base[4] = input
        vim.print(vim.tbl_extend("force", cpp_base, cpp_exec))
        require("code_runner.commands").run_from_fn(vim.list_extend(cpp_base, cpp_exec))
      end)
    end,
    -- VALGRIND CONFIGURATIONS
    c_valgrind = function(...)
      local filename = vim.fn.expand("%:p")
      local tmp_exe = vim.fn.tempname() .. ".out"
      local compile_cmd = string.format("gcc -g -O0 -Wall %s -o %s", filename, tmp_exe)
      
      print("Compiling for Valgrind: " .. compile_cmd)
      local output = vim.fn.system(compile_cmd)
      if vim.v.shell_error ~= 0 then
        print("Compilation failed: " .. output)
        return
      end
      
      local valgrind_cmd = string.format(
        "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose %s",
        tmp_exe
      )
      
      require("code_runner.commands").run_from_fn({
        "cd $dir &&",
        valgrind_cmd,
        "&& rm " .. tmp_exe
      })
    end,
    cpp_valgrind = function(...)
      local filename = vim.fn.expand("%:p")
      local tmp_exe = vim.fn.tempname() .. ".out"
      local compile_cmd = string.format("g++ -g -O0 -Wall %s -o %s", filename, tmp_exe)
      
      print("Compiling for Valgrind: " .. compile_cmd)
      local output = vim.fn.system(compile_cmd)
      if vim.v.shell_error ~= 0 then
        print("Compilation failed: " .. output)
        return
      end
      
      local valgrind_cmd = string.format(
        "valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose %s",
        tmp_exe
      )
      
      require("code_runner.commands").run_from_fn({
        "cd $dir &&",
        valgrind_cmd,
        "&& rm " .. tmp_exe
      })
    end,
    html = {
      "cd $dir &&",
      "xdg-open $fileName"     
    },
    css = {
      "cd $dir &&",
      "xdg-open $fileName"      
    },
    javascript = {
      "cd $dir &&",
      "node $fileName"          
    }
  },
})
