title 'Tests to confirm linux-headers-musl libraries exist'

base_dir = input("base_dir", value: "include")
plan_dirs = input("plan_dirs")
plan_origin = ENV['HAB_ORIGIN']
plan_name = input("plan_name", value: "linux-headers-musl")
plan_ident = "#{plan_origin}/#{plan_name}"

control 'core-plans-linux-headers-musl' do
  impact 1.0
  title 'Ensure linux-headers-musl libraries exist as expected'
  desc '
  We check that the directories that linux-headers-musl installs are present.
  '

  hab_pkg_path = command("hab pkg path #{plan_ident}")
  describe hab_pkg_path do
    its('exit_status') { should eq 0 }
    its('stdout') { should_not be_empty }
  end

  target_dir = File.join(hab_pkg_path.stdout.strip, base_dir)

  plan_dirs.each do | plan_dir |
    describe command("ls -al #{File.join(target_dir, plan_dir)}") do
     its('stdout') { should_not be_empty }
      its('stderr') { should eq '' }
      its('exit_status') { should eq 0 }
    end
  end
end
